import numpy as np
import h5py
import json
from collections import OrderedDict
from pynq import Xlnk
from pynq import Overlay
import sys
import time
import heapq

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

class DMAidx:
    def __init__(self,nBytes,physicalAddress, array):
        self.physical_address = physicalAddress
        self.nbytes = nBytes
        self.array = array
        self.shape = array.shape

    def flush(self):
        self.array.flush()

    def invalidate(self):
        self.array.invalidate()

class DMAUnsafe: #unsafe, but faster, dma transfers
    def __init__(self, dmaChannel):
        self.dmaChannel = dmaChannel
        self.sendAddressAddress = dmaChannel._offset+0x18
        self.sendNBytesAddress = dmaChannel._offset+0x28
        self.waitAddress = dmaChannel._offset+ 4


    def transfer(self,arr):
        self.dmaChannel._mmio.write(self.dmaChannel._offset, 0x1001)
        self.dmaChannel._mmio.write(self.sendAddressAddress, arr.physical_address)
        self.dmaChannel._mmio.write(self.sendNBytesAddress, arr.nbytes)

    def wait(self):
        while not self.dmaChannel._mmio.read(self.waitAddress) & 0x02 == 0x02:
            pass


class NNAccelerator:
    def loadIpParameters(self):
        #read data_W
        self.cnn.write(self.register_map['STATUS_ADD'],3)
        dataW = self.cnn.read(self.register_map['STATUS_VAL'])
        #read data_P
        self.cnn.write(self.register_map['STATUS_ADD'],4)
        dataP = self.cnn.read(self.register_map['STATUS_VAL'])
        #read input DMA bandwidth
        self.cnn.write(self.register_map['STATUS_ADD'],5)
        dmaBW = self.cnn.read(self.register_map['STATUS_VAL'])
        #read PE_N
        self.cnn.write(self.register_map['STATUS_ADD'],7)
        peN = self.cnn.read(self.register_map['STATUS_VAL'])
        #read pe_bw_n
        self.cnn.write(self.register_map['STATUS_ADD'],8)
        peBwN = self.cnn.read(self.register_map['STATUS_VAL'])
        #read wbufSize
        self.cnn.write(self.register_map['STATUS_ADD'],9)
        wbufSize = self.cnn.read(self.register_map['STATUS_VAL'])
        #
        self.cnn.write(self.register_map['STATUS_ADD'],13)
        dataOutN = self.cnn.read(self.register_map['STATUS_VAL'])
        print('dataW: ',dataW, ', dataP: ', dataP, ', dmaBW: ', dmaBW, ', PE_N: ', peN, ', peBwN: ', peBwN, ', dataOut: ', dataOutN, ', wbufSize: ', wbufSize)
        return dataW,dataP,dmaBW,peN,peBwN,dataOutN,wbufSize

    def predict(self, x):#, preConverted = True, imageData = True):
        assert(x.shape[0] == 1),'batch size of 1 only allowed at this time'
        #image = imageData
        #if not imageData:
        #    dmaXbuffer, newDepth = self.allocDmaXArray(x.shape[1], x.shape[3], x.shape[0])
        #    if preConverted:
        #        self.realignDmaBufferX(x,
        #                                    dmaXbuffer,# self.outputs[list(self.layers.keys())[0]],
        #                                    x.shape[3],
        #                                    newDepth,
        #                                    self.DMA_BW)
        #    else:
        #        self.realignDmaBufferX(self.convertToFractional(x),
        #                                    dmaXbuffer,# self.outputs[list(self.layers.keys())[0]],
        #                                    x.shape[3],
        #                                    newDepth,
        #                                    self.DMA_BW)
        #else:
            #self.convertNpToCma(x[0,:,:,:].reshape(x.shape[1]*x.shape[2]*x.shape[3]))

        dmaXbuffer = self.convertNpToCma(x[0,:,:,:])

        ouputsForInput = list()
        ouputsForInput.append(dmaXbuffer)
        self.outputs.update({list(self.layers.keys())[0]:ouputsForInput})
        #only for testing
        #self.outputs['input_2'][-1] = dmaXbuffer
        if self.verboseLevel >= 0.1:
            print('starting prediction')
        before = time.time()
        if self.safeDMA:
            self.dmaParameter.start()
        self.dmaParameter.transfer(self.fullParameters)
        for layer in self.layers:
            #print('predicting: ', layer, ', ', self.layers[layer].type, end= '')
            if self.verboseLevel >= 1.5:
                self.cnn.write(self.register_map['STATUS_ADD'],2)
                nSendtBefore = self.cnn.read(self.register_map['STATUS_VAL'])
                self.cnn.write(self.register_map['STATUS_ADD'],1)
                nReceivedBefore= self.cnn.read(self.register_map['STATUS_VAL'])
            if self.verboseLevel >= 1:
                print('predicting: ', layer, end= '')

            beforePrediction = time.time()
            if self.layers[layer].type == 'Conv2D':
                if self.verboseLevel >= 2:
                    print(', splits: ', self.layers[layer].nSplits, ' ' , end = '')
                output = self.outputs[layer]
                weight = self.weights[layer]
                #parameter = self.parameters[layer]
                currentI = 0
                stitchBufDepth = 0
                stitchDepth = 0
                inputSize = self.layers[self.layers[layer].inputLayer[0]].outputSize[0]
                for i in range(int(self.layers[layer].nSplits)):
                    dmaWbuffer = self.convertNpToCma(weight[i][0])
                    #dmaWbuffer = weight[i][0]
                    newWSize = weight[i][1]
                    newDepth = weight[i][2]
                    nFiltersToLoad = weight[i][3]
                    out = output[i%2]

                    if i > 0:
                        #print(len(output),' - '  , output[i%2].physical_address, ' - ', output[(i+1)%2].physical_address)
                        stitchBufDepth += int(weight[i-1][3]/self.DMA_BW)
                        stitchDepth = stitchBufDepth+(nFiltersToLoad/self.DMA_BW)
                        stitchBuf = output[(i+1)%2]
                        nBytes = int(stitchBufDepth*self.PE_BW*inputSize*inputSize/(self.DMA_BW/2)*8)
                    else:
                        stitchDepth = 0
                        stitchBuf = None
                        nBytes = 0
                    outIdx = self.layers[self.layers[layer].inputLayer[0]].finalOutIdx
                    if self.verboseLevel >= 3:
                        print(', outIdx: ',outIdx, end='')
                    self.doConv(None,#parameter[i],
                                self.outputs[self.layers[layer].inputLayer[0]][outIdx],
                                dmaWbuffer,
                                out,
                                stitchBuf,
                                nBytes)
                    del dmaWbuffer
                    self.layers[layer].finalOutIdx = i%2

            elif self.layers[layer].type == 'Dense':
                if self.verboseLevel >= 2:
                    print('splits: ', self.layers[layer].nSplits, ' ', end = '')
                #parameter = self.parameters[layer]
                output = self.outputs[layer]
                weight = self.weights[layer]
                currentI = 0

                DMAbytesAddPrSplit = self.DATA_WIDTH/8*self.layers[layer].filtersPrSplit

                for i in range(int(self.layers[layer].nSplits)):
                    dmaWbuffer = self.convertNpToCma(weight[i][0])
                    newUnits = weight[i][1]
                    nUnitsToLoad = weight[i][2]
                    outDMA = DMAidx(int(self.outputs[layer][-1].nbytes-(DMAbytesAddPrSplit*i)),
                           int(self.outputs[layer][-1].physical_address + (DMAbytesAddPrSplit*i)),
                           self.outputs[layer][-1])
                    #DMAidx(nBytes,self.outputs[self.layers.inputLayer[0]][-1].physical, array)

                    #outDMA = self.outputs[self.layers.inputLayer[0]][-1]
                    outIdx = self.layers[self.layers[layer].inputLayer[0]].finalOutIdx
                    if self.verboseLevel >= 3:
                        print(', outIdx: ',outIdx, end='')
                    self.doFC(None,#parameter[i],
                                  self.outputs[self.layers[layer].inputLayer[0]][outIdx],
                                  dmaWbuffer,
                                  outDMA)
            elif self.layers[layer].type == 'MaxPooling2D':
                #parameter = self.parameters[layer]
                outIdx = self.layers[self.layers[layer].inputLayer[0]].finalOutIdx
                if self.verboseLevel >= 3:
                    print(', outIdx: ',outIdx, end='')
                self.doPool(None,#parameter[0],
                            self.outputs[self.layers[layer].inputLayer[0]][outIdx],
                            self.outputs[layer][0])
                self.layers[layer].finalOutIdx = 0
            elif self.layers[layer].type == 'InputLayer':
                pass
            else:
                #self.outputs[layer] = self.outputs[self.layers[layer].inputLayer[0]][-1]
                self.layers[layer].finalOutIdx = self.layers[self.layers[layer].inputLayer[0]].finalOutIdx
                #pass
            if 'input' not in layer:
                image = False
            afterPrediction = time.time()
            if self.verboseLevel >= 1:
                print(' layer time: ', afterPrediction-beforePrediction)
                if self.verboseLevel >= 1.5:
                    self.cnn.write(self.register_map['STATUS_ADD'],2)
                    print('nDMAreceived: ',self.cnn.read(self.register_map['STATUS_VAL']) - nSendtBefore, end='')
                    self.cnn.write(self.register_map['STATUS_ADD'],1)
                    print('nDMAsent: ',self.cnn.read(self.register_map['STATUS_VAL']) - nReceivedBefore)
        self.dmaParameter.wait()
        
        layer = list(self.layers.keys())[-1]
        output = self.intVariableExtract(self.outputs[layer][self.layers[layer].finalOutIdx],self.layers[layer].outputSize)
        classes = np.argmax(output)#heapq.nlargest(1,range(len(output)),output.__getitem__)

        after = time.time()
        if self.verboseLevel >= 0.2:
            print('time taken: ', after-before)
            
        return after-before,classes


    def __init__(self, bitfile = None, NNJsonSpec = None, H5Weights = None, preConverted = False, preAlligned = False,verboseLevel = 1,dmaSafe = True):
        #assert(NNJsonSpec != None),"No NN spec found"
        #assert(H5Weights != None),"No weights found"
        self.safeDMA = dmaSafe
        self.verboseLevel = verboseLevel
        self.bitFile = bitfile

        self.overlay = Overlay(bitfile)
        #self.dma = self.overlay.axi_dma_0
        if self.safeDMA:
            self.dmaX = self.overlay.axi_dma_X.sendchannel
            self.dmaY = self.overlay.axi_dma_Y.recvchannel
            self.dmaW = self.overlay.axi_dma_W.sendchannel
            self.dmaBuf = self.overlay.axi_dma_BUF.sendchannel
            self.dmaY._flush_before = False
            self.dmaParameter = self.overlay.axi_dma_CTRL.sendchannel
        else:
            self.dmaX = DMAUnsafe(self.overlay.axi_dma_X.sendchannel)
            self.dmaY = DMAUnsafe(self.overlay.axi_dma_Y.recvchannel)
            self.dmaW = DMAUnsafe(self.overlay.axi_dma_W.sendchannel)
            self.dmaBuf = DMAUnsafe(self.overlay.axi_dma_BUF.sendchannel)
            self.dmaParameter = DMAUnsafe(self.overlay.axi_dma_CTRL.sendchannel)
        self.cnn = self.overlay.cnn_0
        self.xlnk = Xlnk()
        self.xlnk.xlnk_reset()
        #fix for the registers...

        #self.register_map = {'WEIGHT_CTRLS': 0x14,
        #             'CTRL_IMAGE_SIZE': 0x1c,
        #             'CTRL_ROW_SIZE_PKG': 0x24,
        #             'CTRL_WINDOW_SIZE': 0x2c,
        #             'CTRL_DEPTH': 0x34,
        #             'CTRL_STRIDE': 0x3c,
        #             'CTRL_REPLAY': 0x44,
        #             'CTRL_ZEROPAD': 0x4c,
        #             'CTRL_OUTPUT_CHANNEL': 0x54,
        #             'CTRL_STITCH_DEPTH': 0x5c,
        #             'CTRL_STITCH_BUF_DEPTH': 0x64,
        #             'CTRL_DB_OUTPUT':0x6c,
        #             'CTRL_IMAGE_DATA':0x74,
        #             'CTRL_POOL_DEPTH':0x7c,
        #             'CTRL_POOL_TYPE' : 0x84,
        #             'CTRL_POOL_N':0x8c,
        #             'CTRL_POOL_SIZE':0x94,
        #             'CTRL_ROW_N': 0x9c,
        #             'CTRL_ACF': 0xa4,
        #             'START': 0xac,
        #             'READY' : 0xb4,
        #             'STATUS_ADD' : 0xbc,
        #             'STATUS_VAL' : 0xc4}
        self.register_map = {
                     #'START': 0x14,
                     #'READY' : 0x1c,
                     'STATUS_ADD' : 0x14,
                     'STATUS_VAL' : 0x1c
               }

        self.streamRegisterMap = {
            'WEIGHT_CTRLS'         : 0,
            'CTRL_ROW_N'           : 1,
            'CTRL_ROW_SIZE_PKG'    : 2,
            'CTRL_WINDOW_SIZE'     : 3,
            'CTRL_DEPTH'           : 4,
            'CTRL_STRIDE'          : 5,
            'CTRL_REPLAY'          : 6,
            'CTRL_IMAGE_SIZE'      : 7,
            'CTRL_ACF'             : 8,
            'CTRL_ZEROPAD'         : 9,
            'CTRL_OUTPUT_CHANNEL'  : 10,
            'CTRL_STITCH_DEPTH'    : 11,
            'CTRL_STITCH_BUF_DEPTH': 12,
            'CTRL_DB_OUTPUT'       : 13,
            'CTRL_IMAGE_DATA'      : 14,
            'CTRL_POOL_DEPTH'      : 15,
            'CTRL_POOL_TYPE'       : 16,
            'CTRL_POOL_N'          : 17,
            'CTRL_POOL_SIZE'       : 18
        }

        self.overlay.download()
        self.overlay.reset()

        self.DATA_WIDTH, self.DATA_P, self.DMA_BW, self.PE_N, self.PE_BW, self.dbOutN, self.wBufSize = self.loadIpParameters()
        self.DMA_MULT = int(64/self.DATA_WIDTH)
        if self.verboseLevel >= 1:
            print('DMA MULT: ',self.DMA_MULT)

        self.fullParameters = np.zeros(shape=(0,),dtype=np.uint64)
        # load config
        if NNJsonSpec != None:
            with open(NNJsonSpec,'r') as json_file:
                layers = json.load(json_file)

            self.weights = dict()
            #self.bias = dict()
            self.outputs = dict()
            self.parameters = dict()

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
                    if 'lambda' in l.activationFunction or 'relu' in l.activationFunction:
                        l.activationFunction = 'relu'
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
                    print(', paddingSize: ', l.paddingSize, end='')
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
                    l.filtersPrSplit = l.filtersPrSplit-(l.filtersPrSplit%self.DMA_BW)#self.PE_N)
                    l.nSplits = np.ceil((l.nFilters+self.PE_BW*self.dbOutN)/(l.filtersPrSplit))
                    if l.filtersPrSplit > l.nFilters:
                        l.filtersPrSplit = l.nFilters
                    if l.filtersPrSplit*l.nSplits < l.nFilters:
                        l.nSplits += 1
                        print('adding one more split')
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
                print( ', filtersPrSplit: ', l.filtersPrSplit, ', nSplits: ', l.nSplits, ', outputSize: ', l.outputSize)

                self.layers.update({l.name:l})

        #load weight and bias
        if H5Weights != None:
            hf = h5py.File(H5Weights, 'r')
            for groups in hf:
                before = time.time()

                if 'dropout' in groups.lower():
                    continue
                print('loading weights for ', groups, end='')


                if 'Pooling' in self.layers[groups].type:
                    #print('allocating: ', self.layers[groups].outputSize)
                    outputsSplitted = list()
                    outputsSplitted.append(self.allocDmaYArray(
                        self.layers[self.layers[groups].inputLayer[0]].outputSize[0],
                                                                        self.layers[groups].kernelSize[1],
                                                                        self.layers[groups].outputSize[2],
                                                                        self.layers[groups].stride[0],
                                                                        self.layers[groups].paddingSize))
                    self.outputs.update({groups:outputsSplitted})
                elif self.layers[groups].type == 'Flatten':
                    outputsSplitted = list()
                    for p in range(len(self.outputs[self.layers[groups].inputLayer[0]])):
                        outputsSplitted.append(self.outputs[self.layers[groups].inputLayer[0]][p])
                    self.outputs.update({groups:outputsSplitted})

                ##finding weights
                for group in hf[groups]:
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
                        outputsSplitted = list()
                        weightsSplitted = list()
                        start = 0
                        stop = 0
                        if not preAlligned:
                            if preConverted:
                                kernelData = hf[groups][group][kernelGroup][()]#.astype(np.uint64)
                            else:
                                kernelData = self.convertToFractional(hf[groups][group][kernelGroup][()])
                            if self.layers[groups].useBias == True:
                                if preConverted:
                                    biasData = hf[groups][group][biasGroup][()]#.astype(np.uint64)
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
                            if self.verboseLevel >= 4:
                                print('split: ', splitted, ', start: ', start, ', stop: ', stop)

                            dmaWbuffer, newWSize, newDepth = self.allocateDmaWArray(
                                self.layers[groups].kernelSize[0],#kernelShape[1],
                                self.layers[self.layers[groups].inputLayer[0]].outputSize[2],#kernelShape[2],
                                nFiltersToLoad,#kernelShape[3], #number of filters
                                self.layers[groups].stride[0])
                            if not preAlligned:
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
                            else:
                                dmaWbuffer = hf[groups][group][str(splitted)][()]
                            weightsSplitted.append((dmaWbuffer, newWSize, newDepth,nFiltersToLoad))
                            start += np.ceil(self.layers[groups].filtersPrSplit)

                        outputsSplitted.append(self.allocDmaYArray(self.layers[groups].outputSize[0],
                                                                        self.layers[groups].kernelSize[1],
                                                                        self.layers[groups].outputSize[2],
                                                                        self.layers[groups].stride[0],
                                                                        self.layers[groups].paddingSize))
                        if self.layers[groups].nSplits > 1:
                            outputsSplitted.append(self.allocDmaYArray(self.layers[groups].outputSize[0],
                                                                        self.layers[groups].kernelSize[1],
                                                                        self.layers[groups].outputSize[2],
                                                                        self.layers[groups].stride[0],
                                                                        self.layers[groups].paddingSize))
                        self.outputs.update({groups:outputsSplitted})
                        self.weights.update({groups:weightsSplitted})
                        if 'scaleFactor' in hf[groups][group].keys():
                            self.layers[groups].activationScaleFactor = hf[groups][group]['scaleFactor'][()]
                        else:
                            self.layers[groups].activationScaleFactor = 1.0
                    elif self.layers[groups].type == 'Dense':
                        weightsSplitted = list()
                        outputsSplitted = list()
                        start = 0
                        stop = 0
                        inputSize = self.layers[self.layers[groups].inputLayer[0]].outputSize
                        #print('loading kernel and bias data from file')
                        if not preAlligned:
                            if preConverted:
                                kernelData = hf[groups][group][kernelGroup][()]#.astype(np.uint64)
                            else:
                                kernelData =self.convertToFractional(hf[groups][group][kernelGroup][()])
                            if self.layers[groups].useBias == True:
                                if preConverted:
                                    biasData = hf[groups][group][biasGroup][()]#.astype(np.uint64)
                                else:
                                    biasData = self.convertToFractional(hf[groups][group][biasGroup][()])
                            #print(kernelData.shape)
                        for splitted in range(int(self.layers[groups].nSplits)):
                            if splitted == self.layers[self.layers[groups].inputLayer[0]].outputSize-1:
                                nUnitsToLoad = (self.layers[groups].nFilters)-stop
                                stop = None
                            else:
                                nUnitsToLoad = np.ceil(self.layers[groups].filtersPrSplit)
                                stop += nUnitsToLoad
                                stop = int(stop)
                            dmaWbuffer, newUnits = self.allocateDmaWFCArray(inputSize,nUnitsToLoad)
                            #print('split: ', splitted, ', start: ', start, ', stop: ', stop,', nUnitsToLoad: ' ,nUnitsToLoad)
                            if not preAlligned:
                                if self.layers[groups].useBias == True:
                                    self.realignDmaBufferWFC(kernelData[:,int(start):int(stop)],
                                                         biasData[int(start):int(stop)],
                                                         dmaWbuffer,
                                                         self.layers[self.layers[groups].inputLayer[0]].outputSize,
                                                         int(nUnitsToLoad),
                                                         newUnits)
                                else:
                                    self.realignDmaBufferWFC(kernelData[:, int(start):int(stop)],
                                                         None,
                                                         dmaWbuffer,
                                                         self.layers[self.layers[groups].inputLayer[0]].outputSize,
                                                         int(nUnitsToLoad),
                                                         newUnits)

                            else:
                                dmaWbuffer = hf[groups][group][str(splitted)][()]
                            start += np.ceil(self.layers[groups].filtersPrSplit)

                            weightsSplitted.append((dmaWbuffer, newUnits ,nUnitsToLoad))

                        outputsSplitted.append(self.allocateDmaYFCArray(self.layers[groups].outputSize))
                        self.weights.update({groups:weightsSplitted})
                        self.outputs.update({groups:outputsSplitted})
                        if 'scaleFactor' in hf[groups][group].keys():
                            self.layers[groups].activationScaleFactor = hf[groups][group]['scaleFactor'][()]
                        else:
                            self.layers[groups].activationScaleFactor = 1.0
                    else:
                        pass

                after = time.time()



                print(', time taken: ', after-before)#, ', memory status: ', self.xlnk.cma_stats())

        print('parameters')
        self.calcParameters()
        #reset registers
        for register in self.register_map:
            if register is not 'READY' and register is not 'STATUS_VAL':
                self.cnn.write(self.register_map[register],0)

        #self.cnn.write(self.register_map['START'],1)
        #self.cnn.write(self.register_map['START'],0xee)

    def insertInDmaBuffer(self,dma,data,idx):
        #print('data: ', data, ', idx: ', idx)
        dmaIdx = np.uint64(np.floor(idx/(self.DMA_BW/2)))
        #dmaIdx = np.uint64(((dmaIdx+1)%2)+(np.floor(dmaIdx/2)*2))

        internalIdx = np.uint64(idx % (self.DMA_BW/2))
        andExponent = np.uint64(self.DATA_WIDTH*internalIdx)
        andMask = np.uint64(np.invert(np.left_shift(np.uint64(2**(self.DATA_WIDTH)-1),andExponent)))
        dma[dmaIdx] = np.bitwise_or(np.bitwise_and(np.uint64(dma[dmaIdx]),andMask),np.left_shift(np.uint64(data),andExponent))
        #print('dmaIdx: ', dmaIdx, ', internalIdx: ', internalIdx, ', andExponent: ', andExponent, ', andMask: ', hex(andMask), ', dma[dmaIdx]: ', hex(dma[dmaIdx]), ', leftShiftedData: ', hex(np.left_shift(np.uint64(data),andExponent)), ', dma[idx] before: ',hex(np.bitwise_and(np.uint64(dma[dmaIdx]),andMask)))

    def convertToFractional(self,number,p=False): #max 5 dimensions for now -should  be recursive
        negative = np.less(number,0)
        print('number.shape: ',number.shape)
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

        #fractional = np.array(np.round(np.abs(number)*(2**(self.DATA_WIDTH-self.DATA_P-1))),dtype=np.uint64)
        return fractional

    def convertNumberToFractional(self,number,negative):
        fractionalNumber = np.uint64(np.abs(number)*(2**(self.DATA_WIDTH-self.DATA_P)))

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

    def generatorFunc(self,a,b,c,d):
        tmp = ((int(d) & 0xff) << 24) | ((int(c) & 0xff) << 16) | ((int(b) & 0xff) << 8) | ((int(a) & 0xff) << 0)
        #print(hex(np.uint64( tmp << 8)))
        return np.uint64( tmp )

    def generateFuncInv(self,data):
        data = data >> 16
        a = int(data) & 0xFF
        b = (int(data) >> 8) & 0xFF
        c = (int(data) >> 16) & 0xFF
        d = (int(data) >> 24) & 0xFF
        return a, b, c, d

    def variableExtract(self,data, nVariables):
        variables = np.zeros(shape=(nVariables,),dtype=np.float32)
        variableI = 0
        mask = np.uint64(2**(self.DATA_WIDTH-1))
        invMask = np.uint64(np.invert(mask))
        #print('mask: ', hex(mask))
        for i in range(0,int(nVariables/self.PE_BW*2),2):
        #for i in range(0,int(nVariables/self.DMA_BW*2),2):
            for j in range(2):#1,-1,-1):
                for k in range(int(self.DMA_MULT)-1,-1,-1):
                    exponent = np.uint(((self.DATA_WIDTH)*(self.DMA_MULT-(k%self.DMA_MULT)-1)))
                    variable = np.bitwise_and(np.uint(np.right_shift(data[i+j],exponent)),np.uint(2**self.DATA_WIDTH-1))

                    num = np.bitwise_and(np.uint64(variable),invMask)
                    negative = np.int64(np.bitwise_and(np.uint64(variable),mask))

                    variables[variableI] = ((-negative)+num)*(2**(-(self.DATA_WIDTH-self.DATA_P)))
                    variableI += 1
                    if variableI >= nVariables:
                        return variables
        return variables
    
    def intVariableExtract(self,data,nVariables):
        if self.DATA_WIDTH == 16:
            dtype = np.int16
        elif self.DATA_WIDTH == 8:
            dtype = np.int8
        else:
            dtype = np.int
        variables = np.zeros(shape=(nVariables,),dtype=dtype)
        variableI = 0
        #print('mask: ', hex(mask))
        for i in range(0,int(nVariables/self.PE_BW*2),2):
        #for i in range(0,int(nVariables/self.DMA_BW*2),2):
            for j in range(2):#1,-1,-1):
                for k in range(int(self.DMA_MULT)-1,-1,-1):
                    exponent = np.uint(((self.DATA_WIDTH)*(self.DMA_MULT-(k%self.DMA_MULT)-1)))
                    variables[variableI] = np.uint(np.bitwise_and( np.uint(np.right_shift(data[i+j],exponent)),
                                                           np.uint(2**self.DATA_WIDTH-1)))
                    variableI += 1
                    if variableI >= nVariables:
                        return variables
        return variables
    
    def softmax(self,data):
        divisor = np.sum(np.exp(data))
        dOut = np.exp(data)/divisor
        return dOut

    def fixSize(self,old,align):
        tmp = (old % align)
        #print("fixing size -- old: ", old, end="")
        if tmp == 0:
            #print('')
            return old
        else:
            newSize = old + (align - tmp)
            #print(', new: ', newSize)
            return newSize

    def convertNpToCma(self,array):
        dmaArray = self.xlnk.cma_array(shape=array.shape,dtype=array.dtype)#np.uint64)
        self.xlnk.cma_memcopy(dmaArray,array.data,dmaArray.nbytes)
        #for i in range(array.shape[0]):
         #   dmaArray[i] = array[i]
        return dmaArray

    def doCmd(self,registerName, value):#TODO: find out if registermap can be used!
        #print('doCmd: register: ', registerName, ', value: ', value)
        self.cnn.write(self.register_map[registerName.upper()],int(0))
        while self.cnn.read(self.register_map['READY']) == 0:
            pass
        self.cnn.write(self.register_map[registerName.upper()],int(int(value)<<1)|1) #int(np.left_shift(np.uint32(value),np.uint(1)) + 1))
        #while self.cnn.read(self.register_map['READY']) == 0:
         #   pass

    def printStatusReg(self):
        for register in self.register_map:
            print(register, ' = ', self.cnn.read(self.register_map[register.upper()]))

    def realignDmaBufferX(self, data, dmaBuffer,depth,newDepth,dmaBW):
        dmaI = -2
        #print('realignDmaBufferX: depth = ', depth, ', newDepth = ', newDepth, ', length of data = ', len(data))
        for row in range(data.shape[1]):
            for lane in range(data.shape[2]):
                shiftI = self.DMA_MULT#self.PE_BW
                for currentDepth in range(depth):#range(int(newDepth/self.PE_BW)):
                    if currentDepth%self.PE_BW == 0 or int((self.DMA_MULT-(currentDepth%self.DMA_MULT))) == int(self.DMA_MULT):
                        dmaI += 2
                        shiftI = self.DMA_MULT-1#self.PE_BW - 1
                    #if currentDepth%self.PE_BW == 0:
                     #   shiftI = self.PE_BW - 1
                    else:
                        shiftI -= 1
                    exponentMult = ((self.DATA_WIDTH)*(self.DMA_MULT-(shiftI%self.DMA_MULT)-1)) #
                    dmaBuffer[dmaI] = np.bitwise_or(dmaBuffer[dmaI],np.uint64((np.uint64(2**self.DATA_WIDTH-1)&np.uint64(data[0,row,lane,currentDepth]))*2**exponentMult))

    def realignDmaBufferW(self, data, bias, dmaBuffer,depth,newDepth,nW,wSize):
        #print('data.shape: ', data.shape)
        #print('bias.shape: ',bias.shape)
        W_BW = self.PE_BW * self.dbOutN
        #print()
        for i in range(int(nW)):
            if bias.any() != None:
                biasPtrFrom = i
                biasPtrTo = i*(W_BW + ( wSize*wSize*newDepth ))
                #print('biasPtrTo: ', biasPtrTo, ', biasPtrFrom:' , biasPtrFrom, 'data: ', bias[biasPtrFrom])
                self.insertInDmaBuffer(dmaBuffer,bias[biasPtrFrom],biasPtrTo)

            for x in range(wSize):
                for y in range(wSize):
                    for z in range(depth):
                        ptrFrom = (x,y,z,i)

                        zSub = z%self.PE_BW
                        zPtr = np.floor(z/self.PE_BW)

                        ptrTo = ( i * ( W_BW + (wSize*wSize*newDepth))) + (y*wSize*newDepth) + (zPtr*wSize*self.PE_BW) + ((wSize-x-1)*self.PE_BW) + zSub+ W_BW

                        #print('ptrto: ', ptrTo, ', ptrFrom:' , ptrFrom, 'data: ', data[ptrFrom])
                        self.insertInDmaBuffer(dmaBuffer,data[ptrFrom],ptrTo)

    def realignDmaBufferWFC(self, data, bias ,dmaBuffer,nInputs,nOutputs,wRowN):

        print('data.shape: ', data.shape, ', bias.shape: ',bias.shape, ', dmaBuffer.shape: ', dmaBuffer.shape, ', nInputs: ', nInputs ,', nOutputs: ', nOutputs, ', wRowN: ', wRowN)
        nOutputRaw = self.PE_N

        wBW =self.PE_BW * self.dbOutN
        wRowN = self.fixSize(nInputs,wBW)+wBW


        sizeRaw = wRowN*nOutputRaw

        for out in range(nOutputRaw):
            biasPtrFrom = out
            biasPtrTo = out*wBW
            if out < nOutputs:
                self.insertInDmaBuffer(dmaBuffer,bias[biasPtrFrom],biasPtrTo)
            else:
                self.insertInDmaBuffer(dmaBuffer,0,biasPtrTo)

            for ins in range(nInputs):
                ptrFrom = (ins, out)
                inPtrSub = ins%wBW
                inPtrBig = np.floor(ins/wBW)
                ptrTo = ((1+inPtrBig)*nOutputRaw*wBW)+out+wBW+inPtrSub
                #print('out: ', out, ', ptrFrom: ', ptrFrom, ', ptrTo: ', ptrTo)
                if out < nOutputs:
                    self.insertInDmaBuffer(dmaBuffer,data[ptrFrom],ptrTo)
                else:
                    self.insertInDmaBuffer(dmaBuffer,0,ptrTo)


    def realignDmaBufferXFC(self, data, dmaBuffer,depth,newDepth):
        dmaI = -1
        #print('realignDmaBufferX: depth = ', depth, ', newDepth = ', newDepth, ', length of data = ', len(data))
        for currentDepth in range(depth):#range(int(newDepth/self.PE_BW)):
            if (currentDepth)%self.PE_BW == 0 or int((self.DMA_MULT-(currentDepth)%self.DMA_MULT)) == int(self.DMA_MULT):
                dmaI += 1
                shiftI = self.DMA_MULT-1#self.PE_BW - 1
                    #if currentDepth%self.PE_BW == 0:
                     #   shiftI = self.PE_BW - 1
            else:
                shiftI -= 1
            exponentMult = ((self.DATA_WIDTH)*(self.DMA_MULT-(shiftI%self.DMA_MULT)-1)) #
            dmaBuffer[dmaI] = np.bitwise_or(dmaBuffer[dmaI],np.uint64((np.uint64(2**self.DATA_WIDTH-1)&np.uint64(data[currentDepth]))*2**exponentMult))
                #print('row: ', row, ', depth: ', currentDepth-1,', shiftI: ', shiftI, ', dmaI: ', dmaI)

    def allocDmaYArray(self,imageSize, wSize, nWindows,stride,padding):
        assert(stride == 1 or stride%2 ==0),"Unsupported Stride"
        ySize = int((imageSize-wSize+2*padding)/stride +1)
        yDepth = self.fixSize(nWindows, self.PE_N)

        dmaYSize = int((ySize*ySize*yDepth)/(self.DMA_BW/2))
        #print('allocationY array with size: ',dmaYSize, ', from ySize: ', ySize, ', imageSize: ',imageSize, ', wSize: ', wSize, ', nWindows: ', nWindows, ', stride: ',stride, ', padding: ', padding)
        dmaY = self.xlnk.cma_array(shape=(int(np.ceil(dmaYSize)),),dtype=np.uint64)

        return dmaY

    def allocateDmaYFCArray(self, nOut):
        nOutFix = self.fixSize(nOut,self.DMA_BW)
        dmaBuffer = self.xlnk.cma_array(shape=(int(np.ceil(nOutFix/(self.DMA_BW/2)))),dtype=np.uint64)
        return dmaBuffer

    def allocateDmaWArray(self, wSize, depth, nWindows, stride = 1):
        #print('allocDMAWArray: wSize: ',wSize,'depth: ',depth, 'nWindows: ',nWindows, 'stride: ', stride)
        assert(stride == 1 or stride%2 ==0),"Unsupported Stride"
        newDepth = int(self.fixSize(depth, self.PE_BW))
        assert(newDepth % self.PE_BW == 0),"PE_BW unaligned with depth"
        newWSize = int(np.sqrt(self.fixSize(wSize*wSize,(self.PE_BW*self.dbOutN)/newDepth)))
        assert((newWSize*newWSize*newDepth)%(self.PE_BW * self.dbOutN)  == 0),"unaligned new parameters"
        dmaWSize = int(((newWSize * newWSize * newDepth * nWindows)) / (self.DMA_BW/2)+nWindows*(self.PE_BW * self.dbOutN * self.DATA_WIDTH ) /64 )
        #dmaWbuffer = self.xlnk.cma_array(shape=(int(np.ceil(dmaWSize))),dtype=np.uint64)
        dmaWbuffer = np.zeros(shape=(int(np.ceil(dmaWSize))),dtype=np.uint64)
        return dmaWbuffer, newWSize, newDepth

    def allocateDmaWFCArray(self,nInputs,nOutputs):
        nOutputsRaw = self.PE_N

        W_BW = self.PE_BW*self.dbOutN
        wRowN = self.fixSize(nInputs,W_BW)+W_BW

        dmaWSize = int((wRowN * nOutputsRaw) / (self.DMA_BW/2))
        #print('allocating WFC: nInputs: ', nInputs, ', nOutputs: ' , nOutputs, ', dmaSize: ',dmaWSize )
        #dmaW = self.xlnk.cma_array(shape=(int(np.ceil(dmaWSize))),dtype=np.uint64)
        dmaW = np.zeros(shape=(int(np.ceil(dmaWSize))),dtype=np.uint64)

        return dmaW, wRowN

    def allocDmaXArray(self,imageSize, depth, nImages):
        newDepth = int(self.fixSize(depth, self.PE_BW))
        assert(newDepth % self.PE_BW == 0),"PE_BW unaligned with depth"
        assert((imageSize*imageSize*newDepth) % self.PE_BW == 0),"unalligned new depth"

        dmaXSize = int(((imageSize * imageSize * newDepth * nImages)) / (self.DMA_BW/2))
        dmaXbuffer = self.xlnk.cma_array(shape=(int(np.ceil(dmaXSize))),dtype=np.uint64)
        return dmaXbuffer, newDepth


    def doFC(self,parameterBuffer,dmaX,dmaW,dmaY):#, finalSplit = True):
        if self.verboseLevel >= 3:
            print('sending W data')
        if self.safeDMA:
            self.dmaW.start()
        self.dmaW.transfer(dmaW)
        if self.verboseLevel >= 3:
            print('sending X data')
        if self.safeDMA:
            self.dmaX.start()
        self.dmaX.transfer(dmaX)

        if self.safeDMA:
            if parameterBuffer is not None:
                self.dmaParameter.start()
        if parameterBuffer is not None:
            self.dmaParameter.transfer(parameterBuffer)

        #print('FC setup done')

        if self.safeDMA:
            self.dmaY.start()
        self.dmaY.transfer(dmaY)

        if self.safeDMA:
            self.dmaW.wait()
            self.dmaX.wait()
            if parameterBuffer is not None:
                self.dmaParameter.wait()

        if self.verboseLevel >= 3:
            print('waiting for result')

        #if finalSplit == True:
        self.dmaY.wait()


    def doConv(self, parameterBuffer, dmaX, dmaW, dmaY, stitchBuf = None, stitchNbytes = 0):
        if stitchBuf is not None:
            if self.verboseLevel >= 3:
                print(', stitchBuf: ',stitchBuf.shape)
            stitchBufPtr = DMAidx(int(stitchNbytes),stitchBuf.physical_address,stitchBuf)
        #else:
            #print()

        #print('sending W data')
        if self.safeDMA:
            self.dmaW.start()
        self.dmaW.transfer(dmaW)

        if stitchBuf is not None:
            #print('sending buf data')
            if self.safeDMA:
                self.dmaBuf.start()
            self.dmaBuf.transfer(stitchBufPtr)

        #print('sending X data')
        if self.safeDMA:
            self.dmaX.start()
        self.dmaX.transfer(dmaX)
                # setup
        if self.safeDMA:
            if parameterBuffer is not None:
                self.dmaParameter.start()
        if parameterBuffer is not None:
            self.dmaParameter.transfer(parameterBuffer)

        if self.safeDMA:
            self.dmaY.start()
        self.dmaY.transfer(dmaY)

        #print('Conv setup done')

        if self.safeDMA:
            self.dmaW.wait()
            self.dmaX.wait()
            if parameterBuffer is not None:
                self.dmaParameter.wait()

        if stitchBuf is not None:
            self.dmaBuf.wait()

        if self.verboseLevel >= 4:
            print('waiting for result')
        self.dmaY.wait()


    def doPool(self, parameterBuffer, dmaX, dmaY):
        #print('sending X data')
        if self.safeDMA:
            self.dmaX.start()
        self.dmaX.transfer(dmaX)

        if self.safeDMA:
            if parameterBuffer is not None:
                self.dmaParameter.start()
        if parameterBuffer is not None:
            self.dmaParameter.transfer(parameterBuffer)

        #print('pool setup done')
        if self.safeDMA:
            self.dmaY.start()
        self.dmaY.transfer(dmaY)

        if self.safeDMA:
            if parameterBuffer is not None:
                self.dmaParameter.wait()

        if self.safeDMA:
            self.dmaX.wait()
        if self.verboseLevel >= 3:
            print('waiting for result')
        self.dmaY.wait()

    def prepareConv(self, wData,xData,imageSize,wSize,depth,nImages,nW,stride,zeroPad):
        dmaW, newWSize, newDepth = self.allocateDmaWArray(wSize, depth, nW, stride)
        dmaX, newDepth = self.allocDmaXArray(imageSize, depth, nImages)

        self.realignDmaBufferW(wData,self.convertToFractional(np.ones(shape=(nW,))*3), dmaW, depth, newDepth, self.DMA_BW)
        self.realignDmaBufferX(xData, dmaX, depth, newDepth, self.DMA_BW)

        dmaY = self.allocDmaYArray(imageSize, wSize, nW,stride,zeroPad)

        return dmaW,dmaY,dmaX,newWSize, newDepth

    def calcParameters(self):
        before = time.time()
        image = True
        for layer in self.layers:
            if self.layers[layer].type == 'Conv2D':
                paramList = list()
                output = self.outputs[layer]
                weight = self.weights[layer]
                currentI = 0
                stitchBufDepth = 0
                stitchDepth = 0
                inputSize = self.layers[self.layers[layer].inputLayer[0]].outputSize[0]
                for i in range(int(self.layers[layer].nSplits)):
                    newWSize = weight[i][1]
                    newDepth = weight[i][2]
                    nFiltersToLoad = weight[i][3]
                    out = output[i%2]

                    if i > 0:
                        #print(len(output),' - '  , output[i%2].physical_address, ' - ', output[(i+1)%2].physical_address)
                        stitchBufDepth += int(weight[i-1][3]/self.DMA_BW)
                        stitchDepth = stitchBufDepth+(nFiltersToLoad/self.DMA_BW)
                        stitchBuf = output[(i+1)%2]
                        nBytes = int(stitchBufDepth*self.PE_BW*inputSize*inputSize/(self.DMA_BW/2)*8)
                    else:
                        stitchDepth = 0
                        stitchBuf = None
                        nBytes = 0
                    parameterBuffer = self.allocParameterBufferConv()
                    self.parameterCalcConv(parameterBuffer ,
                                           newWSize,
                                           newDepth,
                                           inputSize,
                                           self.layers[layer].stride[0],
                                           1,
                                           nFiltersToLoad,
                                           (self.layers[layer].activationFunction).lower() == 'relu',
                                           self.layers[layer].paddingSize,
                                           stitchDepth,
                                           stitchBufDepth,
                                           imageData = image,
                                           activationScaleFactor = self.layers[layer].activationScaleFactor)
                    paramList.append(parameterBuffer)
                    image = False
            elif self.layers[layer].type == 'Dense':
                if self.verboseLevel >= 2:
                    print('splits: ', self.layers[layer].nSplits, ' ', end = '')
                paramList = list()
                output = self.outputs[layer]
                weight = self.weights[layer]
                currentI = 0

                for i in range(int(self.layers[layer].nSplits)):
                    newUnits = weight[i][1]
                    nUnitsToLoad = weight[i][2]

                    parameterBuffer = self.allocParameterBufferFC()
                    self.parameterCalcFC(parameterBuffer,
                                         self.layers[self.layers[layer].inputLayer[0]].outputSize,
                                         nUnitsToLoad,
                                         newUnits,
                                         (self.layers[layer].activationFunction).lower() == 'relu',
                                         activationScaleFactor = self.layers[layer].activationScaleFactor)
                    paramList.append(parameterBuffer)
                    image = False

            elif self.layers[layer].type == 'MaxPooling2D':
                paramList = list()

                parameterBuffer = self.allocParameterBufferPool()
                self.parameterCalcPool(parameterBuffer,
                                       self.layers[self.layers[layer].inputLayer[0]].outputSize[2],
                                       self.layers[self.layers[layer].inputLayer[0]].outputSize[0],
                                       self.layers[layer].stride[0],
                                       self.layers[layer].kernelSize[0],
                                       self.layers[layer].paddingSize)
                paramList.append(parameterBuffer)
                image = False
            elif self.layers[layer].type == 'InputLayer':
                image = True
                paramList = list()
            else:
                #self.outputs[layer] = self.outputs[self.layers[layer].inputLayer[0]][-1]
                self.layers[layer].finalOutIdx = self.layers[self.layers[layer].inputLayer[0]].finalOutIdx
                paramList = list()
                #pass
            self.parameters.update({layer:paramList})
        self.parameterConcatenation()

    def makeParameter(self, reg, param):
        addr = self.streamRegisterMap[reg.upper()]
        addr = np.uint64(addr*2**56)
        param = np.uint64(param)
        parameter = np.uint64(addr | param)
        return parameter

    def allocParameterBufferFC(self):
        return np.zeros(shape=(14,),dtype=np.uint64)
        #return self.xlnk.cma_array(shape=(14,),dtype=np.uint64)

    def allocParameterBufferConv(self):
        return np.zeros(shape=(15,),dtype=np.uint64)
        #return self.xlnk.cma_array(shape=(15,),dtype=np.uint64)

    def allocParameterBufferPool(self):
        return np.zeros(shape=(15,),dtype=np.uint64)
        #return self.xlnk.cma_array(shape=(15,),dtype=np.uint64)

    def parameterCalcFC(self,parameterBuffer,nIn,nOut,wRowN,ReLu,xN = 1, activationScaleFactor = 1):#, finalSplit = True):
        assert(wRowN % (self.PE_BW * self.dbOutN) == 0),'FC: wrong alignment'
        wbCtrlRowN = (wRowN / (self.PE_BW * self.dbOutN))
        depthRaw = 1
        dbReplay = (nOut/self.PE_N)-1
        rowSizeY = nOut
        imageSize = nIn/self.PE_BW

        parameterBuffer[0] = self.makeParameter('ctrl_image_data', 0)
        parameterBuffer[1] = self.makeParameter('ctrl_depth', 0)
        parameterBuffer[2] = self.makeParameter('ctrl_stride',0)
        parameterBuffer[3] = self.makeParameter('ctrl_window_size', 0)
        parameterBuffer[4] = self.makeParameter('ctrl_row_size_pkg', int(nIn/self.PE_BW))
        if ReLu:
            acf = 1
        else:
            acf = 0
        parameterBuffer[5] = self.makeParameter('ctrl_acf',acf | (int(activationScaleFactor*2**14)<<1))

        parameterBuffer[6] = self.makeParameter('ctrl_output_channel',0)
        parameterBuffer[7] = self.makeParameter('ctrl_db_output',0)

        #setup weight Buffer
        #self.doCmd('ctrl_row_N', 1)
        parameterBuffer[8] = self.makeParameter('weight_ctrls', np.uint(np.left_shift(1,30)))#0)
        #setup db
        parameterBuffer[9] = self.makeParameter('ctrl_zeropad', 0)
        parameterBuffer[10] = self.makeParameter('ctrl_replay', dbReplay)
        parameterBuffer[11] = self.makeParameter('ctrl_image_size',  imageSize)
        parameterBuffer[12] = self.makeParameter('ctrl_stitch_depth',0)
        parameterBuffer[13] = self.makeParameter('ctrl_stitch_buf_depth',0)


    def parameterCalcConv(self, parameterBuffer,window, depth, rowSize, stride, xN, wN, ReLu,zeroPad, stitchDepth = 0,stitchBufDepth = 0, imageData = False, activationScaleFactor = 1):
        assert(depth % self.PE_BW == 0),"unaligned!"
        depthRaw = depth / self.PE_BW
        assert((window * window * depth) % (self.PE_BW * self.dbOutN) == 0),"unaligned"
        wbCtrlRowN = ((window * window * depth) / (self.PE_BW * self.dbOutN))+1
        dbReplay = np.ceil(wN / self.PE_N)-1
        assert(stride % 2 == 0 or stride == 1),'invalid stride'
        rowSizeY = (rowSize-window+2*zeroPad)/stride +1
        imageSize = depthRaw*rowSize*rowSize

        # setup
        parameterBuffer[0] = self.makeParameter('weight_ctrls', 0 | (int(wbCtrlRowN)<<20))
        if imageData:
            parameterBuffer[1] = self.makeParameter('ctrl_image_data', 1)
        else:
            parameterBuffer[1] = self.makeParameter('ctrl_image_data', 0)
        parameterBuffer[2] = self.makeParameter('ctrl_depth', depthRaw)
        parameterBuffer[3] = self.makeParameter('ctrl_stride',stride-1)
        parameterBuffer[4] = self.makeParameter('ctrl_window_size', window)
        parameterBuffer[5] = self.makeParameter('ctrl_row_size_pkg', rowSize)
        if ReLu:
            acf = 1
        else:
            acf = 0
        parameterBuffer[6] = self.makeParameter('ctrl_acf',acf | (int(activationScaleFactor*2**14)<<1))

        parameterBuffer[7] = self.makeParameter('ctrl_output_channel',0)
        parameterBuffer[8] = self.makeParameter('ctrl_db_output',0)

        #setup weight Buffer
        #self.doCmd('ctrl_row_N', 1)#wbCtrlRowN);
        parameterBuffer[9] = self.makeParameter('weight_ctrls', (xN * rowSizeY * rowSizeY))#-1)
        #setup db
        parameterBuffer[10] = self.makeParameter('ctrl_zeropad', zeroPad)
        parameterBuffer[11] = self.makeParameter('ctrl_replay', dbReplay);
        parameterBuffer[12] = self.makeParameter('ctrl_image_size', imageSize);
        parameterBuffer[13] = self.makeParameter('ctrl_stitch_depth',stitchDepth)
        parameterBuffer[14] = self.makeParameter('ctrl_stitch_buf_depth',stitchBufDepth)

    def parameterCalcPool(self, parameterBuffer,depth, rowSize, stride, window, zeroPad, xN = 1):
        assert(depth%self.PE_BW == 0),'unaligned depth'
        depthRaw = np.floor(depth/self.PE_BW)
        dbReplay = 1
        rowSizeY = (rowSize-window+2*zeroPad)/stride +1
        imageSize = depthRaw*rowSize*rowSize
        if self.verboseLevel >= 3:
            print( 'depth: ', depth, ', rowSize: ',rowSize, ', stride: ',stride, ', window: ',window,', zeroPad:',zeroPad,', depthRaw: ', depthRaw,', rowSizeY: ', rowSizeY,  ', imageSize: ', imageSize)

        parameterBuffer[0] = self.makeParameter('ctrl_image_data', 0)
        parameterBuffer[1] = self.makeParameter('ctrl_depth',int(depthRaw))
        parameterBuffer[2] = self.makeParameter('ctrl_stride',int(stride-1))
        parameterBuffer[3] = self.makeParameter('ctrl_window_size',int(window))
        parameterBuffer[4] = self.makeParameter('ctrl_row_size_pkg',int(rowSize))
        parameterBuffer[5] = self.makeParameter('ctrl_output_channel',int(1))
        parameterBuffer[6] = self.makeParameter('ctrl_db_output',int(1))
        parameterBuffer[7] = self.makeParameter('ctrl_zeropad',int(zeroPad))
        parameterBuffer[8] = self.makeParameter('ctrl_replay',int(dbReplay))
        parameterBuffer[9] = self.makeParameter('ctrl_image_size',int(imageSize))

        parameterBuffer[10] = self.makeParameter('ctrl_pool_size',int(window))
        parameterBuffer[11] = self.makeParameter('ctrl_pool_type',int(0))# 0 = maxPool, 1 = minPool, 2 = averagePooling(disabled)
        parameterBuffer[12] = self.makeParameter('ctrl_pool_depth',int(depth))
        parameterBuffer[13] = self.makeParameter('ctrl_stitch_depth',0)
        parameterBuffer[14] = self.makeParameter('ctrl_stitch_buf_depth',0)

    def parameterConcatenation(self):
        parameters = np.zeros(shape=(0,),dtype=np.uint64)
        for layer in self.layers:
            for p in self.parameters[layer]:
                parameters = np.concatenate((parameters,p))
        print('fullParameters.shape: ', parameters.shape)
        self.fullParameters = self.convertNpToCma(parameters)
