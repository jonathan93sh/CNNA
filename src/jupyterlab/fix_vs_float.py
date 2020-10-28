#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Nov 12 20:08:25 2019

@author: jonathan
"""

import numpy as np

#W = 16
#I = 2



float_val = np.float32(1.1)
print(float_val)


def fix_round_test(W,I,offset):
    P = W-I
    fix_min = 2**-P
    
    #offset = 0.500
    
    float_val_min = np.float32(fix_min)
    float_val_between = float_val_min+(float_val_min*np.float32(offset))
    float_val_scale_up=float_val_between*np.float32(2)**P
    float_val_round = np.round(float_val_scale_up)
    float_val_scale_down = float_val_round*np.float32(2)**-P
    
    Wd = W*2
    Id = I*2
    Pd = Wd-Id
    
    def print_fix(x, w, i):
        val = float(x)*2**-(w-i)
        #print(val)
        return val
        
        
    fixed_double_min = int(2**(Wd-Id-P))
    print_fix(fixed_double_min,Wd,Id)
    fixed_double_between = fixed_double_min + int(fixed_double_min*offset)
    print_fix(fixed_double_between,Wd,Id)
    
    fixed_round = int(np.floor(fixed_double_between*2**(P-Pd)))
    msr = int((fixed_double_between&(1<<(Wd-Id-P-1)))>>(Wd-Id-P-1))
    fixed_round =fixed_round+msr
    fixed_round_float = print_fix(fixed_round,W,I)
    
    error = np.abs( float(float_val_scale_down)-float(fixed_round_float))
    print(error)
    assert(error <= fix_min*0.1)


for W in [4,8,16,32]:
    for offset_i in range(0,2000):
        fix_round_test(W,2,(offset_i*0.0001)-1)




#fixed_