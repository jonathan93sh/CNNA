#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Oct 23 12:03:28 2019

@author: jonathan
"""

from PIL import Image
import numpy as np

def load_image( infilename ) :
    img = Image.open( infilename )
    img.load()
    data = np.asarray( img)#, dtype="int32" )
    return data

dog_image = load_image("dog32x32x3.png")

dog_image = dog_image / 255

np.save("dog.npy",dog_image)

f= open("dog.txt","w")

for x in range(np.shape(dog_image)[0]):
    for y in range(np.shape(dog_image)[1]):
        for z in range(np.shape(dog_image)[2]):
            f.write(str(dog_image[x,y,z])+'\n')
            
f.close()