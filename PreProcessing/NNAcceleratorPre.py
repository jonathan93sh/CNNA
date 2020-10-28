import numpy as np
import h5py
import time
import json
from collections import OrderedDict
from threading import Thread

class NNLayerSpec:
    def __init__(self):
        self.name = ''
        self.activationFunction = ''
        self.type = ''
        self.inputShape = -1
        self.outputShape = -1
        self.weightShape = ''
        self.inputLayer = list()
        self.useBias = True
        self.stride = (1)
        self.padding = ''
        self.kernelSize = (0)
        self.paddingSize = 0
        self.nFilters = 0
        self.nSplits = 0
        self.filtersPrSplit = 0
        self.finalOutIdx = 0
        self.activationScaleFactor = 1

    def __str__(self):
        return 'Name: ' + str(self.name) + ', Type: ' + str(self.type) + ', Activation Function: ' + str(self.activationFunction)

class NNAcceleratorPre():
    def __init__(self,dataW,dataP,dmaBW,peN,peBW,dataOutN,wBufSize,h5Name,autoScale = True):
        self.DATA_WIDTH = dataW
        self.DATA_P = dataP
        self.DMA_BW = dmaBW
        self.PE_N = peN
        self.PE_BW = peBW
        self.dbOutN = dataOutN
        self.wBufSize = wBufSize
        self.h5Name = h5Name
        self.threads = list()
        self.autoScale = autoScale
        self.useThreads = True
        print('dataW: ', self.DATA_WIDTH, ', dataP: ', self.DATA_P ,', dmaBW: ', self.DMA_BW, ', PE_N: ', self.PE_N, ', PE_BW: ', self.PE_BW, ', dbOutN: ', self.dbOutN, ', wBufSize: ', self.wBufSize)

    def scale(self, values, scaleFactor):
        #print("scale factor " ,scaleFactor, "shape values: ", values.shape, ", type values: ", type(values))
        newValues = values*scaleFactor
        #print("newValues shape: ", newValues.shape, ", newValues type: ",type(newValues))
        return newValues

    def fixSize(self,old,align):
        tmp = (old % align)
        print("fixing size -- old: ", old, end="")
        if tmp == 0:
            print('')
            return old
        else:
            newSize = old + (align - tmp)
            print(', new: ', newSize)
            return newSize

    def realignDmaBufferW(self, data, bias, dmaBuffer,depth,newDepth,nW,wSize):
        #print('data.shape: ', data.shape)
        #print('bias.shape: ',bias.shape)
        W_BW = self.PE_BW * self.dbOutN
        #print()
        for i in range(int(nW)):
            if bias.any() != None:
                biasPtrFrom = i

                peIndexSub = i % self.PE_N
                peIndexPtr = np.floor(i/self.PE_N)

                #biasPtrTo = i*(W_BW + ( wSize*wSize*newDepth ))
                biasPtrTo = (peIndexSub*W_BW) + (peIndexPtr*self.PE_N*(W_BW + (wSize*wSize*newDepth)))
                #print('biasPtrTo: ', biasPtrTo, ', biasPtrFrom:' , biasPtrFrom, 'data: ', bias[biasPtrFrom])
                self.insertInDmaBuffer(dmaBuffer,bias[biasPtrFrom],biasPtrTo)

            for x in range(wSize):
                for y in range(wSize):
                    for z in range(depth):
                        ptrFrom = (x,y,z,i)

                        zSub = z%self.PE_BW
                        zPtr = np.floor(z/self.PE_BW)

                        #ptrTo = ( i * ( W_BW + (wSize*wSize*newDepth))) + (y*wSize*newDepth) + (zPtr*wSize*self.PE_BW) + ((wSize-x-1)*self.PE_BW) + zSub+ W_BW
                        ptrToSub = (y*wSize*newDepth)+(zPtr*wSize*self.PE_BW) + ((wSize-x-1)*self.PE_BW)+zSub+W_BW

                        ptrToPESub = ptrToSub % W_BW
                        ptrToPEPtr = np.floor(ptrToSub / W_BW)

                        ptrTo = biasPtrTo+ptrToPEPtr*(self.PE_N*W_BW)+ptrToPESub
                        #print('ptrTo: ',ptrTo, ' , ptrFrom: ', ptrFrom)
                        #prptrToPESub = ptrToSub % W_BWint('ptrto: ', ptrTo, ', ptrFrom:' , ptrFrom, 'data: ', data[ptrFrom])
                        self.insertInDmaBuffer(dmaBuffer,data[ptrFrom],ptrTo)

    def insertInDmaBuffer(self,dma,data,idx):
        #print('data: ', data, ', idx: ', idx)
        dmaIdx = np.uint64(np.floor(idx/(self.DMA_BW/2)))
        internalIdx = np.uint64(idx % (self.DMA_BW/2))
        andExponent = np.uint64(self.DATA_WIDTH*internalIdx)
        andMask = np.uint64(np.invert(np.left_shift(np.uint64(2**(self.DATA_WIDTH)-1),andExponent)))
        #print('dmaIdx: ', dmaIdx, ', internalIdx: ', internalIdx,end='')

        dma_tmp = np.bitwise_or(np.bitwise_and(np.uint64(dma[dmaIdx]),andMask),np.left_shift(np.uint64(data),andExponent))
        #print(dma_tmp)
        dma[dmaIdx] = dma_tmp
        #print(', andExponent: ', andExponent, ', andMask: ', hex(andMask), ', dma[dmaIdx]: ', hex(dma[dmaIdx]), ', leftShiftedData: ', hex(np.left_shift(np.uint64(data),andExponent)), ', dma[idx] before: ',hex(np.bitwise_and(np.uint64(dma[dmaIdx]),andMask)))

    def allocateDmaWFCArray(self,nInputs,nOutputs):
        nOutputsRaw = self.PE_N

        W_BW = self.PE_BW*self.dbOutN
        wRowN = self.fixSize(nInputs,W_BW)+W_BW

        dmaWSize = int((wRowN * nOutputsRaw) / (self.DMA_BW/2))
        #print('allocating WFC: nInputs: ', nInputs, ', nOutputs: ' , nOutputs, ', dmaSize: ',dmaWSize )
        #dmaW = self.xlnk.cma_array(shape=(int(np.ceil(dmaWSize))),dtype=np.uint64)
        dmaW = np.zeros(shape=(int(np.ceil(dmaWSize))),dtype=np.uint64)

        return dmaW, wRowN

    def allocateDmaWArray(self, wSize, depth, nWindows, stride = 1):
        print('allocDMAWArray: wSize: ',wSize,'depth: ',depth, 'nWindows: ',nWindows, 'stride: ', stride)
        assert(stride == 1 or stride%2 ==0),"Unsupported Stride"
        newDepth = int(self.fixSize(depth, self.PE_BW))
        assert(newDepth % self.PE_BW == 0),"PE_BW unaligned with depth"
        newWSize = int(np.sqrt(self.fixSize(wSize*wSize,(self.PE_BW*self.dbOutN)/newDepth)))
        assert((newWSize*newWSize*newDepth)%(self.PE_BW * self.dbOutN)  == 0),"unaligned new parameters"
        dmaWSize = int(((newWSize * newWSize * newDepth * nWindows)) / (self.DMA_BW/2)+nWindows*(self.PE_BW * self.dbOutN * self.DATA_WIDTH ) /64 )
        #dmaWbuffer = self.xlnk.cma_array(shape=(int(np.ceil(dmaWSize))),dtype=np.uint64)
        dmaWbuffer = np.zeros(shape=(int(np.ceil(dmaWSize))),dtype=np.uint64)
        return dmaWbuffer, newWSize, newDepth

    def realignDmaBufferWFC(self, data, bias ,dmaBuffer,nInputs,nOutputs,wRowN):

        print('data.shape: ', data.shape, ', bias.shape: ',bias.shape, ', dmaBuffer.shape: ', dmaBuffer.shape, ', nInputs: ', nInputs ,', nOutputs: ', nOutputs, ', wRowN: ', wRowN)
        nOutputRaw = self.PE_N

        wBW =self.PE_BW * self.dbOutN
        #wRowN = self.fixSize(nInputs,wBW)+wBW

        #sizeRaw = wRowN*nOutputRaw

        for out in range(nOutputRaw):
            biasPtrFrom = out
            biasPtrTo = out*wBW
            if out < nOutputs:
                self.insertInDmaBuffer(dmaBuffer,bias[biasPtrFrom],biasPtrTo)
            else:
                self.insertInDmaBuffer(dmaBuffer,0,biasPtrTo)

            for ins in range(int(nInputs)):
                ptrFrom = (ins, out)
                inPtrSub = ins%wBW
                inPtrBig = np.floor(ins/wBW)
                ptrTo = ((1+inPtrBig)*nOutputRaw*wBW)+out*wBW+inPtrSub
                print('out: ', out, ', ptrFrom: ', ptrFrom, ', ptrTo: ', ptrTo)
                if out < nOutputs:
                    self.insertInDmaBuffer(dmaBuffer,data[ptrFrom],int(ptrTo))
                else:
                    self.insertInDmaBuffer(dmaBuffer,int(0),int(ptrTo))

    def convert(self,H5Weights):
        hf = h5py.File(H5Weights, 'r+')
        for groups in hf:
            for group in hf[groups]:
                for grou in hf[groups][group]:
                    before = time.time()
                    print('doing ', groups,':',group,':',grou , end='')
                    fractional = self.convertToFractional(hf[groups][group][grou][()]).astype(np.uint64)
                    #print(', fractional shape: ', fractional.shape, end='')
                    hf[groups][group][grou][...] = fractional
                    after = time.time()
                    print(', time taken: ', after-before)
        hf.close()

    def realign(self,hf,hfOut,groups,preConverted):
        hfOut.create_group(groups)
        before = time.time()
        if 'dropout' in groups.lower():
            return
        print('loading weights for ', groups, ', type: ',self.layers[groups].type, end='')
        ##finding weights
        for group in hf[groups]:
            hfOut[groups].create_group(group)
            biasShape = 0
            kernelShape = 0
            for grou in hf[groups][group]:
                if 'bias' in grou:
                    biasGroup = grou
                    biasShape = hf[groups][group][grou].shape
                elif 'kernel' in grou:
                    kernelGroup = grou
                    kernelShape = hf[groups][group][grou].shape
            if self.layers[groups].type == 'Conv2D':
                #weightsSplitted = list()
                start = 0
                stop = 0
                if preConverted:
                    kernelData = hf[groups][group][kernelGroup][()]
                    scaleFactor = 1
                else:
                    if self.autoScale:
                        scaleFactor = np.max(hf[groups][group][kernelGroup][()])
                        #print("scaleFactor pre division " , scaleFactor, ", 2^self.DATA_P:" , 2**self.DATA_P, "DATA_P : ", self.DATA_P)
                        scaleFactor = scaleFactor/(2**self.DATA_P)
                        scaledCoeffs = self.scale(hf[groups][group][kernelGroup][()],1/scaleFactor)
                        kernelData = self.convertToFractional(scaledCoeffs)
                    else:
                        kernelData = self.convertToFractional(hf[groups][group][kernelGroup][()])
                    #print('scaleFactor: ', scaleFactor)
                if self.layers[groups].useBias == True:
                    if preConverted:
                        biasData = hf[groups][group][biasGroup][()]
                    else:
                        if self.autoScale:
                            scaledCoeffs = self.scale(hf[groups][group][biasGroup][()],1/scaleFactor)
                            biasData = self.convertToFractional(scaledCoeffs)
                        else:
                            biasData = self.convertToFractional(hf[groups][group][biasGroup][()])

                for splitted in range(int(self.layers[groups].nSplits)):
                    if splitted == self.layers[groups].nSplits-1:
                        nFiltersToLoad = self.layers[groups].nFilters-stop
                        stop = None
                    else:
                        nFiltersToLoad = np.ceil(self.layers[groups].filtersPrSplit)
                        stop += nFiltersToLoad
                        stop = int(stop)
                    print('split: ', splitted, ', start: ', start, ', stop: ', stop)

                    dmaWbuffer, newWSize, newDepth = self.allocateDmaWArray(
                        kernelShape[1],
                        kernelShape[2],
                        nFiltersToLoad,#kernelShape[3], #number of filters
                        self.layers[groups].stride[0])
                    if self.layers[groups].useBias == True:
                        self.realignDmaBufferW( kernelData[:,:,:,int(start):stop],
                                              biasData[int(start):stop],
                                              dmaWbuffer,
                                              kernelShape[2],
                                              newDepth,
                                              nFiltersToLoad,
                                              kernelShape[0])
                    else:
                        self.realignDmaBufferW( kernelData[:,:,:,int(start):stop],
                                              None,
                                              dmaWbuffer,
                                              kernelShape[2],
                                              newDepth,
                                              nFiltersToLoad,
                                              kernelShape[0])
                    hfOut[groups][group].create_dataset(str(splitted),data=dmaWbuffer)
                    #weightsSplitted.append((dmaWbuffer, newWSize, newDepth,nFiltersToLoad))

                    start += np.ceil(self.layers[groups].filtersPrSplit)
                if self.autoScale:
                    hfOut[groups][group].create_dataset('scaleFactor',data=scaleFactor)
                #self.weights.update({groups:weightsSplitted})
            elif self.layers[groups].type == 'Dense':
                #weightsSplitted = list()
                start = 0
                stop = 0
                inputSize = self.layers[self.layers[groups].inputLayer[0]].outputSize
                #print('loading kernel and bias data from file')
                if preConverted:
                    kernelData = hf[groups][group][kernelGroup][()]
                    scaleFactor = 1
                else:
                    if self.autoScale:
                        scaleFactor = np.max(hf[groups][group][kernelGroup][()])/(2**self.DATA_P)
                        scaledCoeffs = self.scale(hf[groups][group][kernelGroup][()],1/scaleFactor)
                        kernelData = self.convertToFractional(scaledCoeffs)
                    else:
                        kernelData = self.convertToFractional([groups][group][kernelGroup][()])

                if self.layers[groups].useBias == True:
                    if preConverted:
                        biasData = hf[groups][group][biasGroup][()]
                    else:
                        if self.autoScale:
                            scaledCoeffs = self.scale(hf[groups][group][biasGroup][()],1/scaleFactor)
                            biasData = self.convertToFractional(scaledCoeffs)
                        else:
                            biasData = self.convertToFractional(hf[groups][group][biasGroup][()])
                #print(kernelData.shape)
                for splitted in range(int(self.layers[groups].nSplits)):
                    if splitted == self.layers[groups].nSplits-1:
                        nUnitsToLoad = self.layers[groups].outputSize-stop
                        stop = None
                    else:
                        nUnitsToLoad = np.ceil(self.layers[groups].filtersPrSplit)
                        stop += nUnitsToLoad
                        stop = int(stop)
                    dmaWbuffer, newUnits = self.allocateDmaWFCArray(inputSize,nUnitsToLoad)
                    #print('split: ', splitted, ', start: ', start, ', stop: ', stop,', nUnitsToLoad: ' ,nUnitsToLoad, ', self.layers[groups].outputSize : ', self.layers[groups].outputSize)

                    if self.layers[groups].useBias == True:
                        self.realignDmaBufferWFC(kernelData[:,int(start):stop],
                                                 biasData[int(start):stop],
                                                 dmaWbuffer,
                                                 self.layers[self.layers[groups].inputLayer[0]].outputSize,
                                                 int(nUnitsToLoad),
                                                 newUnits)
                    else:
                        self.realignDmaBufferWFC(kernelData[:, int(start):stop],
                                                 None,
                                                 dmaWbuffer,
                                                 self.layers[self.layers[groups].inputLayer[0]].outputSize,
                                                 int(nUnitsToLoad),
                                                 newUnits)

                    hfOut[groups][group].create_dataset(str(splitted),data=dmaWbuffer)
                    start += np.ceil(self.layers[groups].filtersPrSplit)
                    #weightsSplitted.append((dmaWbuffer, newUnits ,nUnitsToLoad))
                    #print('allocating: ', nUnitsToLoad*self.layers[self.layers[groups].inputLayer[0]].outputSize)
                if self.autoScale:
                    hfOut[groups][group].create_dataset('scaleFactor',data=scaleFactor)

                print('allocating: ', self.layers[groups].outputSize)
                #self.weights.update({groups:weightsSplitted})
            else:
                pass
        after = time.time()
        print(', time taken: ', after-before)

    def pre(self,NNJsonSpec,H5Weights,preConverted):
        # load config
        if NNJsonSpec != None:
            with open(NNJsonSpec,'r') as json_file:
                layers = json.load(json_file)

            self.weights = dict()
            self.outputs = dict()

            self.layers = OrderedDict()
            for layer in layers['config']['layers']:
                l = NNLayerSpec()

                l.name = layer['name']
                l.type = layer['class_name']
                l.inputLayer = list()

                for node in layer['inbound_nodes']:
                    for nod in node:
                        for no in nod:
                            if no != 0 and no != {}:
                                l.inputLayer.append(no)


                if 'activation' in layer['config'].keys():
                    l.activationFunction = layer['config']['activation']
                if 'use_bias' in layer['config'].keys():
                    l.useBias = layer['config']['use_bias']
                if 'kernel_size' in layer['config'].keys():
                    l.kernelSize = layer['config']['kernel_size']
                elif 'pool_size' in layer['config'].keys():
                    l.kernelSize = layer['config']['pool_size']
                elif 'units' in layer['config'].keys():
                    l.kernelSize = layer['config']['units']
                if 'strides' in layer['config'].keys():
                    l.stride = layer['config']['strides']
                if 'filters' in layer['config'].keys():
                    l.nFilters = layer['config']['filters']


                if 'padding' in layer['config'].keys():
                    l.padding = layer['config']['padding']
                    if l.padding == 'same':
                        l.paddingSize = (l.kernelSize[0]-1)/2
                    else:
                        l.paddingSize = 0
                    #print(', paddingSize: ', l.paddingSize, end='')
                    #padding temporarily disabled!
                    #l.paddingSize = 0
                if len(l.inputLayer) == 0:
                    l.outputSize = layer['config']['batch_input_shape'][1:]
                elif l.type == 'Flatten':
                    tmpSize = self.layers[l.inputLayer[0]].outputSize
                    l.outputSize = tmpSize[0]*tmpSize[1]*tmpSize[2]
                elif l.type == 'Dense':
                    l.outputSize = layer['config']['units']
                else:
                    tmpSize = (self.layers[l.inputLayer[0]].outputSize[0]
                               -l.kernelSize[0]
                               +2*l.paddingSize)/l.stride[0]+1
                    if l.nFilters == 0:
                        l.outputSize =(tmpSize,
                                       tmpSize,
                                       self.layers[l.inputLayer[0]].nFilters)
                    else:
                        l.outputSize = (tmpSize,tmpSize,l.nFilters)

                print(l.name, ', kernelSize: ',l.kernelSize, ', nFilters: ',l.nFilters  , end='')
                if int(l.nFilters) != 0:
                    l.filtersPrSplit = (np.floor(((self.wBufSize*self.PE_N*self.PE_BW*self.dbOutN) /
                                        (l.kernelSize[0]*l.kernelSize[1]*
                                         self.layers[l.inputLayer[0]].outputSize[2]+
                                         self.PE_BW*self.dbOutN) )))
                    print('debug: filtersprsplit:', l.filtersPrSplit, (self.wBufSize*self.PE_N*self.PE_BW*self.dbOutN),l.kernelSize[0]*l.kernelSize[1]*self.layers[l.inputLayer[0]].outputSize[2],self.PE_BW*self.dbOutN)
                    l.filtersPrSplit = l.filtersPrSplit-(l.filtersPrSplit%self.DMA_BW)#self.PE_N)
                    print('debug: filtersprsplit:', l.filtersPrSplit)
                    l.nSplits = np.ceil((l.nFilters+self.PE_BW*self.dbOutN)/(l.filtersPrSplit))
                    if l.filtersPrSplit > l.nFilters:
                        l.filtersPrSplit = l.nFilters
                    if l.filtersPrSplit*l.nSplits < l.nFilters:
                        l.nSplits += 1
                        #print('adding one more split')
                    if l.nSplits*l.filtersPrSplit >= l.nFilters+l.filtersPrSplit:
                        while l.nSplits*l.filtersPrSplit >= l.nFilters+l.filtersPrSplit:
                            l.nSplits -= 1
                else:
                    if l.type == 'Dense':
                        l.filtersPrSplit = self.PE_N
                        l.nSplits = np.ceil(l.outputSize/self.PE_N)
                    else:
                        l.filtersPrSplit = l.nFilters
                        l.nSplits = 1
                print( ', filtersPrSplit: ', l.filtersPrSplit, ', nSplits: ', l.nSplits, ', outputSize: ', l.outputSize, ', l.filtersPrSplit*l.nSplits:' ,l.filtersPrSplit*l.nSplits)

                self.layers.update({l.name:l})

            #load weight and bias
            if H5Weights != None:
                hf = h5py.File(H5Weights, 'r')
                hfOut = h5py.File(H5Weights[:-5]+'_pre_'+self.h5Name+'.h5','w')
                if self.useThreads == True:
                    for groups in hf:
                        self.threads.append( Thread(target = self.realign, args = (hf,hfOut,groups,preConverted)))

                    for threads in self.threads:
                        threads.start()
                    for threads in self.threads:
                        threads.join()
                else:
                    for groups in hf:
                        self.realign(hf,hfOut,groups,preConverted)

                hfOut.close()

    def convertNumberToFractional(self,number,negative):
        fractionalNumber = np.uint64(np.round(np.abs(number)*(2**(self.DATA_WIDTH-self.DATA_P))))

        if negative == True:
            bitMask = np.uint64(2**(self.DATA_WIDTH)-1)
            invertedFractional = np.uint64(np.invert(fractionalNumber))
            invertedAndedFractional = np.uint64(np.bitwise_and(invertedFractional,bitMask))
            fractional = np.uint64(invertedAndedFractional+1)
            #print('fractionalNumber: ', hex(fractionalNumber) , ', bitMask: ', hex(bitMask), ', invertedFractional: ', hex(invertedFractional), ', invertedAndedFractional: ', hex(invertedAndedFractional), ', fractional: ', hex(fractional))
            return fractional
        else:
            #print('fractionalNumber: ', hex(fractionalNumber))
            return fractionalNumber

    def convertToFractional(self,number,p=False): #max 5 dimensions for now -should  be recursive
        negative = np.less(number,0)
        #print(', number.shape: ',number.shape, end='')
        fractional = np.ndarray(shape=number.shape,dtype=np.float64)

        for d in range(number.shape[0]):
            if number[d].ndim == 0:
                fractional[d] = self.convertNumberToFractional(number[d],negative[d])
            else:
                for i in range(number[d].shape[0]):
                    if number[d,i].ndim == 0:
                        fractional[d,i] = self.convertNumberToFractional(number[d,i],negative[d,i])
                    else:
                        for j in range(number[d,i].shape[0]):
                            if number[d,i,j].ndim == 0:
                                fractional[d,i,j] = self.convertNumberToFractional(number[d,i,j],negative[d,i,j])
                            else:
                                for k in range(number[d,i,j].shape[0]):
                                    if number[d,i,j,k].ndim == 0:
                                        fractional[d,i,j,k] = self.convertNumberToFractional(number[d,i,j,k],negative[d,i,j,k])
                                    else:
                                        for l in range(number[d,i,j,k].shape[0]):
                                            if number[d,i,j,k,l].ndim == 0:
                                                fractional[d,i,j,k,l] = self.convertNumberToFractional(number[d,i,j,k,l],negative[d,i,j,k,l])
        #fractional = np.clip(fractional,-2**self.DATA_P,2**(self.DATA_P)-(2**(-(self.DATA_WIDTH-self.DATA_P))))
        #if not np.allclose(number, fractional, rtol=0.0001, atol=1e-07):
        #    print('WARNING error in precision')
        return fractional

