import NNAcceleratorPre
from threading import Thread

accCNNA8_1 = NNAcceleratorPre.NNAcceleratorPre(8,       #dataW
                                                2,      #dataP
                                                16 ,    #dmaBW
                                                8,      #peN
                                                16,     #peBW
                                                3,      #dataOutN
                                                546,    #wBufSize
                                                'cnna7.8.8.3.546') ##naming: cnnaX.dataW.peN.dataOutN.wBufSize
accCNNA8_2 = NNAcceleratorPre.NNAcceleratorPre(8,       #dataW
                                                2,      #dataP
                                                16,     #dmaBW
                                                16,     #peN
                                                16,     #peBW
                                                1,      #dataOutN
                                                798,     #wBufSize
                                                'cnna7.8.16.1.798')
accCNNA16 = NNAcceleratorPre.NNAcceleratorPre(16,       #dataW
                                                2,      #dataP
                                                8,      #dmaBW
                                                8,      #peN
                                                8,      #peBW
                                                3,      #dataOutN
                                                800,     #wBufSize
                                                'cnna7.16.8.3.800')
accCNNA32 = NNAcceleratorPre.NNAcceleratorPre(32,       #dataW
                                                2,      #dataP
                                                4,      #dmaBW
                                                8,      #peN
                                                4,      #peBW
                                                1,      #dataOutN
                                                2900,     #wBufSize
                                                'cnna7.32.8.1.2900',
                                                False)

jsonName = 'VGG16_detect.json'
weightName = 'VGG16_detect.hdf5'

threads = list()

#threads.append( Thread(target = accCNNA8_1.pre, args = (jsonName,weightName,False)))
#threads.append( Thread(target = accCNNA8_2.pre, args = (jsonName,weightName,False)))
#threads.append( Thread(target = accCNNA16.pre, args = (jsonName,weightName,False)))
threads.append( Thread(target = accCNNA32.pre, args = (jsonName,weightName,False)))

for thread in threads:
    thread.start()
for thread in threads:
    thread.join()

print("realignment done")