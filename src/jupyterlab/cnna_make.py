#!/bin/python
#%%
import os
import numpy as np
from lxml import etree
import matplotlib.pyplot as plt

def fix_size_align(old, align):
    tmp = (old % align);
    if tmp == 0:
        return old
    else:
        return old + (align - tmp)
    
def fix_size_pkg(old, align):    
    while True:
        if old >= align:
            return align        
        tmp = align / old;        
        if tmp == float(int(tmp)):
            return old        
        old = old + 1

def fix_size_power2(old):
    tmp = np.log2(old)
    if tmp == float(int(tmp)):
        return old
    else:
        return int(2**int(np.ceil(tmp)))

def param_make(P_data_P=8, P_data_W=16, P_input_width=128,  P_output_width=128, P_pe_n=4, P_pe_bw_n=4, P_data_out_n=3,N_bias = 64, W_max=(3*3*512)*64, X_depth_max=512, X_row_depth_size_max=512*64, conv_max=3, fix_align=True, fix_bw=True, P_PE_pipeline_II=1, P_pe_pre_fifo_deep=1, HLS_DEBUG_LEVEL=999, P_X_fifo_deep=1, P_Y_fifo_deep=1, P_BUF_fifo_deep=1,P_W_fifo_deep=1):
    
        
    
    if fix_align:
        P_data_out_n = fix_size_pkg(P_data_out_n, conv_max)
        #P_PE_pipeline_II = fix_size_pkg(P_PE_pipeline_II, P_pe_n*P_pe_bw_n*P_data_out_n)
        P_input_width = fix_size_align(P_input_width,32)
        P_output_width = fix_size_align(P_output_width,32)
        P_data_W = fix_size_pkg(P_data_W, P_input_width)
        P_pe_n = fix_size_power2(P_pe_n)
        if fix_bw:
            P_pe_bw_n = P_input_width/P_data_W
        else:
            P_pe_bw_n = fix_size_power2(P_pe_bw_n)
    
    
        
    
    P_wbuf_size=np.ceil(W_max/(P_pe_n*P_pe_bw_n*P_data_out_n))+N_bias
    P_data_buf_clb_size=X_row_depth_size_max/P_pe_bw_n
    P_data_buf_clb_n=conv_max
    P_data_buf_shift_size=np.ceil(X_depth_max*conv_max/P_pe_bw_n)
    P_pool_size=1024#X_depth_max*#fix_size_align(X_depth_max,P_data_out_n*P_pe_bw_n)
    
    if fix_align:
        if P_data_P >= P_data_W:
            P_data_P = P_data_W
        
        
   
    
    N_BRAM = 432
    
    BRAM_SIZE = 18000
    
    BRAM_APPROX_USED_CLB = np.ceil((P_data_buf_clb_n*P_data_buf_clb_size*P_data_W*P_pe_bw_n)/BRAM_SIZE)
    BRAM_APPROX_USED_SHIFT = np.ceil( (P_data_buf_shift_size*P_data_W*P_pe_bw_n*conv_max)/BRAM_SIZE)
    BRAM_APPROX_USED_WB =np.ceil( (P_wbuf_size*P_pe_n*P_pe_bw_n*P_data_out_n*P_data_W)/BRAM_SIZE)
    
    BRAM_APPROX_USED_fifo = np.round((P_pe_pre_fifo_deep*P_pe_n*2*P_data_W*P_pe_bw_n*P_data_out_n)/BRAM_SIZE)
    BRAM_APPROX_USED_fifo += np.round((P_X_fifo_deep*P_input_width)/BRAM_SIZE)
    BRAM_APPROX_USED_fifo += np.round((P_Y_fifo_deep*P_input_width)/BRAM_SIZE)
    BRAM_APPROX_USED_fifo += np.round((P_BUF_fifo_deep*P_input_width)/BRAM_SIZE)
    BRAM_APPROX_USED_fifo += np.round((P_W_fifo_deep*P_input_width)/BRAM_SIZE)
    
   
    BRAM_APPROX_USED_POOL = np.ceil((P_pool_size*P_data_W/P_data_out_n)/BRAM_SIZE)*P_data_out_n
    
    BRAM_USED = BRAM_APPROX_USED_CLB + BRAM_APPROX_USED_SHIFT + BRAM_APPROX_USED_WB + BRAM_APPROX_USED_fifo + BRAM_APPROX_USED_POOL
    
    if P_data_W <= 18:
        DSP_pr_mul = 1
    else:
        DSP_pr_mul = 4
    
    N_MUL = np.ceil((P_pe_n*P_pe_bw_n*P_data_out_n)/P_PE_pipeline_II)*(DSP_pr_mul)
    
    print("used BRAM: " + str(BRAM_USED) + " / " + str(N_BRAM) + ", (CLB: " + str(BRAM_APPROX_USED_CLB) + ", SHIFT: " + str(BRAM_APPROX_USED_SHIFT) + ", WB: " + str(BRAM_APPROX_USED_WB) + ", fifo: " + str(BRAM_APPROX_USED_fifo) + ", pool: " + str(BRAM_APPROX_USED_POOL) + ")")
    print("used Multiplyer: " + str(N_MUL) + " (total DSP 360)")
    
    
    paramdict = {
        "P_data_P":P_data_P, "P_data_W":P_data_W, "P_input_width":P_input_width,  "P_output_width":P_output_width, "P_pe_n":P_pe_n, "P_pe_bw_n":P_pe_bw_n, "P_data_out_n":P_data_out_n, "W_max":W_max, "X_depth_max":X_depth_max, "X_row_depth_size_max":X_row_depth_size_max, "conv_max":conv_max, "P_PE_pipeline_II":P_PE_pipeline_II, "P_pe_pre_fifo_deep":P_pe_pre_fifo_deep, "P_X_fifo_deep":P_X_fifo_deep, "P_Y_fifo_deep":P_Y_fifo_deep, "P_BUF_fifo_deep":P_BUF_fifo_deep,"P_W_fifo_deep":P_W_fifo_deep   
    }
            
    param = 'PARAM_LIST=\'P_data_P=' + str(int(P_data_P)) + ' P_data_W='+str(int(P_data_W)) + ' P_X_fifo_deep=' +str(int(P_X_fifo_deep)) + ' P_Y_fifo_deep='+str(int(P_Y_fifo_deep)) + ' P_BUF_fifo_deep=' + str(int(P_BUF_fifo_deep)) + ' P_W_fifo_deep=' + str(int(P_W_fifo_deep))  + ' HLS_DEBUG_LEVEL='+ str(int(HLS_DEBUG_LEVEL)) + ' P_input_width='+str(int(P_input_width))+'  P_output_width='+str(int(P_output_width))+' P_pe_n='+str(int(P_pe_n))+' P_pe_bw_n='+str(int(P_pe_bw_n))+' P_wbuf_size='+str(int(P_wbuf_size))+' P_data_buf_clb_size='+str(int(P_data_buf_clb_size))+' P_data_buf_clb_n='+str(int(P_data_buf_clb_n))+' P_data_buf_shift_size='+str(int(P_data_buf_shift_size))+' P_data_out_n='+str(int(P_data_out_n))+' P_PE_pipeline_II='+str(int(P_PE_pipeline_II))+' P_pe_pre_fifo_deep='+str(int(P_pe_pre_fifo_deep))+' P_pool_size='+str(int(P_pool_size))+'\''
    return [param, BRAM_USED,N_MUL,paramdict]

def getHash(param='',path='../'):
    return os.popen('cd '+path+';make hash ' + param).read()[:-1]

def getLogFolder(param='',path='../'):
    return os.popen('cd '+path+';make logfolder ' + param).read()[:-1]

print(param_make()[0])
print('hash code is: ' + getHash(param_make()[0]))


def CNNA_make_csim(param='',path='../', workers=2, logfile='cnna_make.log'):
    hash_code = getHash(param,path)
    print('exec: make -C ' + path + ' run_cnna '+param+' -j' + str(workers) + '> '+logfile+' 2>&1 ')
    if os.system('make -C ' + path + ' run_cnna '+param+' -j' + str(workers) + '> '+logfile+' 2>&1 ') == 0:
        return [True, hash_code]
    else:
        return [False, hash_code]


    

def CNNA_make(param='',path='../', workers=2,target='build_ip'):
    hash_code = getHash(param,path)
    print('exec: make -C ' + path + ' ' + target + ' ' +param+' -j' + str(workers) + '> cnna_make.log 2>&1 ')
    if os.system('make -C ' + path + ' ' + target + ' ' +param+' -j' + str(workers) + '> cnna_make.log 2>&1 ') == 0:
        return [True, hash_code]
    else:
        return [False, hash_code]
    

    
    
def getxmlelem(xml_element,tag):
    return [s for s in xml_element if s.tag == tag][0]

def getResource(xmlfile):
    xml_file = etree.parse(xmlfile)#'/home/jonathan/git/CNNAccel/src/IP/CNNAccel/default/syn/report/csynth.xml')
    r = xml_file.getroot()
    AreaEstimates = getxmlelem(r,"AreaEstimates")
    UserAssignments = getxmlelem(r,"UserAssignments")
    TargetClockPeriod = float(getxmlelem(UserAssignments, "TargetClockPeriod").text)
    ClockUncertainty = float(getxmlelem(UserAssignments, "ClockUncertainty").text)
    PerformanceEstimates = getxmlelem(r,"PerformanceEstimates")
    SummaryOfTimingAnalysis = getxmlelem(PerformanceEstimates,"SummaryOfTimingAnalysis")
    EstimatedClockPeriod = float(getxmlelem(SummaryOfTimingAnalysis,"EstimatedClockPeriod").text)
    ret = []
    
    BRAM = float(getxmlelem(AreaEstimates[0], "BRAM_18K").text)
    DSP = float( getxmlelem(AreaEstimates[0], "DSP48E").text)
    FF = float(getxmlelem(AreaEstimates[0], "FF").text)
    LUT = float(getxmlelem(AreaEstimates[0], "LUT").text)
    URAM = float(getxmlelem(AreaEstimates[0], "URAM").text)
    ret.append([EstimatedClockPeriod, BRAM, DSP, FF, LUT, URAM])
    BRAM =  float(getxmlelem(AreaEstimates[1], "BRAM_18K").text)
    DSP =  float(getxmlelem(AreaEstimates[1], "DSP48E").text)
    FF = float(getxmlelem(AreaEstimates[1], "FF").text)
    LUT = float(getxmlelem(AreaEstimates[1], "LUT").text)
    URAM = float(getxmlelem(AreaEstimates[1], "URAM").text)
    ret.append([TargetClockPeriod-ClockUncertainty,BRAM, DSP, FF, LUT, URAM])
    print("ok xml")
    print(ret)
    return ret

def strTime2float(s):
    tmp = s.split(" ")
    #print(tmp)
    time = float(tmp[0])
    if tmp[1][:-1] == "ps":
        time = time*(10**-12)
    elif tmp[1][:-1] == "ns":
        time = time*(10**-9)
    elif tmp[1][:-1] == "us":
        time = time*(10**-6)
    elif tmp[1][:-1] == "ms":
        time = time*(10**-3)
    elif tmp[1][:-1] == "s":
        time = time
    else:
        time = np.inf
        print("error time limit exceeded")
        raise Exception("error time limit exceeded (getResult) s: " + s)  
    return time
    

def getResult(result_file='../result.txt'):
    fd = open(result_file, 'r')
    last = ""
    mse = "0"
    for l in fd.readlines():
        if l.split(":")[0]=="mse":
            mse=l.split(":")[1]
        else:
            last = l.split(":")[1]
        
        print(l)
        
    
    tmp = last.split(" ")
    print(tmp)
    time = float(tmp[0])
    if tmp[1][:-1] == "ps":
        time = time*(10**-12)
    elif tmp[1][:-1] == "ns":
        time = time*(10**-9)
    elif tmp[1][:-1] == "us":
        time = time*(10**-6)
    elif tmp[1][:-1] == "ms":
        time = time*(10**-3)
    elif tmp[1][:-1] == "s":
        time = time
    else:
        time = np.inf
        print("error time limit exceeded")
        raise Exception("error time limit exceeded (getResult)")  
   
    return [time, float(mse)]

def getResultVGG19test(result_file='../result.txt'):
    fd = open(result_file, 'r')
    res = dict()
    start_str = fd.readline()
    #mse_str = fd.readline()
    end_str = fd.readline()
    time = strTime2float(end_str.split(":")[1])-strTime2float(start_str.split(":")[1])
    #mse = float(mse_str.split(":")[1])
    res.update({'pool512':[time,0.0]})
    start_str = fd.readline()
    mse_str = fd.readline()
    end_str = fd.readline()
    time = strTime2float(end_str.split(":")[1])-strTime2float(start_str.split(":")[1])
    mse = float(mse_str.split(":")[1])
    res.update({'conv-64':[time,mse]})
    start_str = fd.readline()
    mse_str = fd.readline()
    end_str = fd.readline()
    time = strTime2float(end_str.split(":")[1])-strTime2float(start_str.split(":")[1])
    mse = float(mse_str.split(":")[1])
    res.update({'conv':[time,mse]})
    start_str = fd.readline()
    #mse_str = fd.readline()
    end_str = fd.readline()
    time = strTime2float(end_str.split(":")[1])-strTime2float(start_str.split(":")[1])
    #mse = float(mse_str.split(":")[1])
    res.update({'pool':[time,0.0]})
    start_str = fd.readline()
    mse_str = fd.readline()
    end_str = fd.readline()
    time = strTime2float(end_str.split(":")[1])-strTime2float(start_str.split(":")[1])
    mse = float(mse_str.split(":")[1])
    res.update({'fc':[time,mse]})
    res.update({'final':[strTime2float(end_str.split(":")[1]),0.0]})
    res.update({'ok':True})
    return res
    

def getCost():
    res = getResource()
    offset = np.add(np.multiply(res[1],[0,0,0.15,0,1,0]),0.0000001)
    cost = np.divide(res[0], np.add(res[1],offset))
    return np.max(cost)


def CNNA_csim_res(param='',path='../', workers=2,logfile='cnna_make.log'):
    ret = CNNA_make_csim(param,path,workers,logfile)
    print(ret)
    
    if ret[0]:
        try: 
            res = getResultVGG19test('../build/' + ret[1] + '/src/hwcore/tb/cnn/result.txt')
        except Exception as e:
            print("error: param:" + str(param) + ", ret: " + str(ret) +", errmsg: " + str(e))
            return {'ok': False}
        
        return res
    else:
        tmp=dict()
        tmp.update({'ok':False})
        return tmp

param_make(P_pe_n=2,P_data_W=8)

#ret = CNNA_make(param_make(P_pe_n=2, P_pe_bw_n=4),workers=4)
#%%
if False:


    result = []
    
    for pe_n in [8, 16]:
        for pipeline in [1, 8]:
            param = param_make(P_pe_n=pe_n, P_PE_pipeline_II=pipeline, P_pe_pre_fifo_deep=5)
            ret = CNNA_make_csim(param[0],workers=3)
            
            print(ret)
            if ret[0]:
                result.append([pe_n, pipeline,getResultVGG19test('../build/' + ret[1] + '/src/hwcore/tb/cnn/result.txt'), param[1], param[2]])
            
    #%%
                
        
    plt.plot([a[4] for a in result ], [a[2]['conv'] for a in result ])
    plt.show()
    plt.plot([a[0] for a in result ], [a[1] for a in result ])
    plt.show()
    
    
    #res = getCost()
    #%%
    
    
    
    CNNA_make(param_make(P_pe_n=16,P_PE_pipeline_II=2,P_pe_pre_fifo_deep=8)[0],workers=8, target='build_ip_unsafe')
    
    #%%
    
    CNNA_make(param_make(P_data_P=5, P_data_W=8,P_pe_n=16,P_PE_pipeline_II=1,P_pe_pre_fifo_deep=1,W_max=(3*3*512+32)*64)[0],workers=8)
    
    os.system('poweroff')
    
    #%%
    CNNA_make(param_make(P_data_P=2, P_data_W=16,P_pe_n=8,P_PE_pipeline_II=1,P_pe_pre_fifo_deep=1,W_max=(3*3*512+(3*8))*42,P_data_out_n=3)[0],workers=8)
    os.system('poweroff')
    
    #%%
    logdir = '../'+getLogFolder(param_make(P_pe_n=4,P_PE_pipeline_II=1,P_pe_pre_fifo_deep=8)[0])
    logdir = '../'+'./IP_catalog/CNNAccel-3.102.upgrade.118-c6fbc6a-597439216333'+'/csynth.xml'
    getResource(logdir)
    
    #%%
    
    CNNA_make_csim(param_make(P_pe_n=8,P_data_P=2, P_data_W=16,W_max=3*3*512*128, P_X_fifo_deep=256, P_Y_fifo_deep=256, P_BUF_fifo_deep=256,P_W_fifo_deep=256)[0],workers=8)

