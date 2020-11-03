#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct 31 10:11:56 2019

@author: jonathan
"""
import os
import numpy as np
import cnna_make as cnna
import pickle
import matplotlib.pyplot as plt
#import multiprocessing as mp
from multiprocessing import Pool, TimeoutError
import time
save_id='180Mhz.p'

#version_tag = 'CNNAccel-3.61.CNNA_upgrade_29'

#%% Word-length OPT

# define object funtion 
if True:
    init_wordlengt = [8,4] # fixed16.16
    
    target_mse = 1e-3
    
    N_param = 1*2
    
    def cnna_model_csim(param):
        try:
            if param[4] < param[2]:
                param[4] = param[2]
            
            paramstr = cnna.param_make(
                            P_data_P=2, 
                            P_data_W=param[0], 
                            P_input_width=param[1],  
                            P_output_width=param[1], 
                            P_pe_n=param[2], 
                            P_data_out_n=param[3],
                            HLS_DEBUG_LEVEL=0, 
                            #P_pe_bw_n=4, 
                            N_bias = param[4],
                            W_max = 3*3*512*param[4], 
                            X_depth_max=512, 
                            #X_row_depth_size_max=(224+2)*64*2, 
                            conv_max=3, 
                            P_PE_pipeline_II=1, 
                            P_pe_pre_fifo_deep=1
                            )
            ret_sim = cnna.CNNA_csim_res(paramstr[0],logfile='\''+str(param)+'HEB.log'+'\'',workers=8)
            if not ret_sim['ok']:
                ret =  [np.inf, np.inf, np.inf, ret_sim,paramstr,param]
            else:
                mse = np.sqrt(np.power(ret_sim['conv'][1],2)+np.power(ret_sim['fc'][1],2))
                N_bram = 432
                N_dsp = 360
                cost = ((paramstr[1]/N_bram) + (paramstr[2]/N_dsp))/2
                ret =  [mse, cost,ret_sim['final'][0],ret_sim,paramstr,param]
        except Exception as e:
            print("error cnna_model_csim : param:" + param + ", ret_sim: " + ret_sim +", errmsg: " + str(e))
            return [np.inf, np.inf, np.inf, {'ok':False},[],param]
        
        print(ret)
        return ret
    
    
    def cnna_model_csim_dummy(param):
        print("start")
        time.sleep(5)
        print("ok")
        return param
    
    result = []
    
    param_list=[]
    
    for W in [32,16,8]:#,32]:
        for dma_W in [128,64]:#, 128]:
            for pe_n in [4,8, 16,32, 64]:
                for data_out_n in [3,1]:
                    param_list.append([W, dma_W, pe_n, data_out_n, 64])
                    #param = [W, dma_W, pe_n, data_out_n, 64]
                    #print(param)
                    #result.append([cnna_model_csim(param),param])
                    
                    #print('done')
    if False:
        test = cnna_model_csim([16,128,4,1,64])
    #%%
    
    pool = Pool(processes=16)
    
    result = pool.map(cnna_model_csim, param_list)
    
    pickle.dump([result,param_list],open( 'cp01-'+save_id, "wb" ))
    
    
    #%%
    
    def pred(x):
        return  x[4][3]['P_input_width'] == 128 #x[4][3]['P_data_W'] == 16 and#
    
    def max_usage(x):
        N_bram = 432
        N_dsp = 360
        used_dsp = x[4][2]
        used_bram = x[4][1]
        return np.max([used_dsp/N_dsp,used_bram/N_bram])
    
    def avg_usage(x):
        N_bram = 432
        N_dsp = 360
        used_dsp = x[4][2]
        used_bram = x[4][1]
        
        return np.average([used_dsp/N_dsp,used_bram/N_bram])
    
    def plot_result(pred,predx,texton,label,dot,saveas,newfig=True):
    
        x = [predx(x) for x in result if x[0] != np.inf and pred(x)]#x[3]['conv'][0]+x[3]['conv-64'][0]+x[3]['fc'][0]
        
        y = [avg_usage(x) for x in result if x[0] != np.inf and pred(x)]
        
        text = [('['+str(x[5][2]) + ','+ str(x[5][3])+']') for x in result if x[0] != np.inf and pred(x)]
        if newfig:
            plt.figure(figsize=(8, 5)) 
            plt.xlabel('latency [s]')
            plt.ylabel('resource %')
            
        
        
        
        curplt =plt.scatter(x,y,marker=dot)
        curplt.set_label(label)
        
        #,right=0.03) 
        #plt.ylim(0) 
        #plt.grid()
    #plt.xscale('log')
        if texton:
            for [x_, y_, t_] in zip(x,y,text):
                
                plt.text(x_,y_,t_)
    
    #lt.savefig('parato_csim.png')
    #plt.close(fig)
    
    list_of_predx = [['2xconv_fc',lambda x:x[3]['conv'][0]+x[3]['conv-64'][0]+x[3]['fc'][0]],
                     ['pool',lambda x:x[3]['pool'][0]],
                     ['pool512',lambda x:x[3]['pool512'][0]],
                     ['conv',lambda x:x[3]['conv'][0]],
                     ['conv-64',lambda x:x[3]['conv-64'][0]],
                     ['fc',lambda x:x[3]['fc'][0]],
                     ['final',lambda x:x[3]['final'][0]]
                    ]
    for px in list_of_predx:
        plot_result(lambda x:x[4][3]['P_input_width'] == 128 and x[4][3]['P_data_W'] == 8 and max_usage(x) <= 1.0,px[1],True,'8 bit','o','')
        plot_result(lambda x:x[4][3]['P_input_width'] == 128 and x[4][3]['P_data_W'] == 16 and max_usage(x) <= 1.0,px[1],True,'16 bit','^','',False)
        plot_result(lambda x:x[4][3]['P_input_width'] == 128 and x[4][3]['P_data_W'] == 32 and max_usage(x) <= 1.0,px[1],True,'32 bit','X','',False)
        plt.legend()
        plt.title(px[0] + ' - Pareto Valid designs [approx/csim]')
        plt.yscale('log',basey=10)
        plt.xlim(left=0)
        plt.grid()
        #plt.grid()
        plt.savefig(px[0] +'pareto_Valid_designs_csim.png')
        plt.show()
        plt.close()
        
        plot_result(lambda x:x[4][3]['P_input_width'] == 128 and x[4][3]['P_data_W'] == 8,px[1],True,'8 bit','o','')
        plot_result(lambda x:x[4][3]['P_input_width'] == 128 and x[4][3]['P_data_W'] == 16,px[1] ,True,'16 bit','^','',False)
        plot_result(lambda x:x[4][3]['P_input_width'] == 128 and x[4][3]['P_data_W'] == 32 ,px[1],True,'32 bit','X','',False)
        plt.legend()
        plt.title(px[0] + ' - Pareto designs [approx/csim]')
        plt.yscale('log',basey=10)
        plt.xlim(left=0)
        plt.grid()
        #plt.grid()
        plt.savefig(px[0] +'pareto_designs_csim.png')
        plt.show()
        plt.close()
        
        plot_result(lambda x:x[4][3]['P_input_width'] == 128 and x[4][3]['P_data_W'] == 16 and max_usage(x) <= 1.0,px[1],True,'16 bit valid','^','')
        plot_result(lambda x:x[4][3]['P_input_width'] == 128 and x[4][3]['P_data_W'] == 16 and max_usage(x) > 1.0,px[1],True,'16 bit invalid','v','',False)
        plt.legend()
        plt.title(px[0] + ' - Pareto 16bit designs [approx/csim]')
        plt.yscale('log',basey=10)
        plt.xlim(left=0)
        plt.grid()
        
        plt.savefig(px[0] +'pareto_16bit_designs_csim.png')
        plt.show()
        plt.close()
        #os.system('systemctl suspend')
#%%


def cnna_model_make(param):
    if param[4] < param[2]:
        param[4] = param[2]
    
    paramstr = cnna.param_make(
                    P_data_P=2, 
                    P_data_W=param[0], 
                    P_input_width=param[1],  
                    P_output_width=param[1], 
                    P_pe_n=param[2], 
                    P_data_out_n=param[3],
                    HLS_DEBUG_LEVEL=0, 
                    #P_pe_bw_n=4, 
                    N_bias = param[4],
                    W_max = 3*3*512*param[4], 
                    X_depth_max=512, 
                    #X_row_depth_size_max=(224+2)*64*2, 
                    conv_max=3, 
                    P_PE_pipeline_II=1, 
                    P_pe_pre_fifo_deep=1
                    )
    ret_sim = cnna.CNNA_make(paramstr[0],workers=8,target='build_bit')
    return [ret_sim,paramstr]

#%%
if False:
    top3_list16 = [[16,128,8,3,32], [16,128,32,1,32],[16,128,16,3,32]]
    top3_list8 = [[8,128,16,1,42],[8,128,8,3,42],[8,128,32,1,42]]
    result_rtl = []
    for p in top3_list16:
        result_rtl.append(cnna_model_make(p))
        os.system('git add ../IP_catalog/')
        os.system('git commit -m "new bit upload: '+ p +'"')
        os.system('git push')
        
    for p in top3_list8:
        result_rtl.append(cnna_model_make(p))
        os.system('git add ../IP_catalog/')
        os.system('git commit -m "new bit upload: '+ p +'"')
        os.system('git push')

#%%
if False:
    p = [16,128,8,3,32]
    test = cnna_model_make(p)
    pickle.dump([test],open( 'save_tmp.p', "wb" ))
    os.system('systemctl suspend')
    
    #%% V2 200MHz
    
    top3_list16 = [[16,128,32,1,32],[16,128,16,3,32],[16,128,8,3,32]]#[16,128,8,3,32], 
    top3_list8 = [[8,128,16,1,42],[8,128,8,3,42],[8,128,32,1,42]]
    result_rtl_200 = []
    
    for p in top3_list16:
        result_rtl_200.append(cnna_model_make(p))
        os.system('git add ../IP_catalog/')
        os.system('git commit -m "new bit upload"')
        os.system('git push')
        
    for p in top3_list8:
        result_rtl_200.append(cnna_model_make(p))
        os.system('git add ../IP_catalog/')
        os.system('git commit -m "new bit upload"')
        os.system('git push')
    
    pickle.dump([result_rtl_200],open( 'save_rtl200_tmp.p', "wb" ))
    
    os.system('systemctl suspend')


test = cnna_model_make([16,128,8,3,32]) # Paper CNNA16
#test = cnna_model_make([8,128,16,1,42]) # Paper CNNA8_1
#test = cnna_model_make([8,128,8,3,42]) # Paper CNNA8_2
print(test)

#for p in top3_list16:
#    result_rtl.append(cnna_model_make(p))
    
#for p in top3_list8:
#    result_rtl.append(cnna_model_make(p))
