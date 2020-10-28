# train.py - training and testing of models

import utils
from dl_models.CNN_models import get_model, get_model_from
from augmentator import Augmentator
# -- gives errors for import
from dl_optimizers.own_optimizers import Cyclical_Adam, Adam_fix, gen_reluFix, SGD_fix,gen_softmaxFix
from dl_optimizers.own_optimizers import get_lr_scheduler_cyclical
from dl_optimizers.own_optimizers import get_lr_scheduler_triangular

import pandas as pd
import numpy as np
import os
from os import path
import matplotlib.pyplot as plt
from datetime import datetime
import getpass


import tensorflow as tf
from tensorflow import keras
from keras.callbacks import ModelCheckpoint, LearningRateScheduler, TensorBoard, EarlyStopping, ReduceLROnPlateau
from keras.models import load_model, save_model, Model
from keras.optimizers import Adam, SGD
from keras.preprocessing.image import ImageDataGenerator, img_to_array, load_img
import keras.backend as K
from keras.layers import Activation
from keras.utils.generic_utils import get_custom_objects
#from tensorflow.keras import backend as k
# https://www.tensorflow.org/install/gpu - Need CUDA 10.0, cuDNN >=7.4.1, tensorflow >= 1.13
# cuDNN 7.4.1 not available on conda ==> get tensorflow-gpu==1.12.0 med  CUDA 9.0 og cuDNN == 7.3.1
# conda install tensorflow-gpu==1.12.0 || eller pip install tensorflow-gpu==1.12.0
config = tf.ConfigProto()
config.gpu_options.allow_growth = True
sess = tf.Session(config=config)
keras.backend.set_session(sess)

# current date and time
now = datetime.now()
now_t = datetime.time(now)

timestamp = "{}{}_time_{}_{}_{}".format(now.strftime(
    "%b"), now.day, now_t.hour, now_t.minute, now_t.second)

# The default input size is 224x224.
verbose = 1
seed = 69


def get_callbacks(model_name):
    # Define model checkpoint
    checkpoint = ModelCheckpoint(
        'dl_weights/%s-epoch{epoch:02d}-acc{acc:.4f}-loss{loss:.4f}'
        '-valacc{val_acc:.4f}-valloss{val_loss:.4f}.hdf5' % model_name,
        monitor='loss',
        save_best_only=True,
        save_weights_only=True,
        mode='auto',
        period=10,  # checkpoint every epoch #number
        verbose=verbose
    )

    # Define early stopping
    early_stop = EarlyStopping(
        monitor='loss',
        min_delta=0,
        patience=10,
        mode='auto'
    )

    # Add Tensorboard logging
    tb = TensorBoard("./train_final_small_tb_logs/"+model_name+"/"+timestamp)

    return [checkpoint, tb]


def magic(model_name, opt, lrs, fc_layers=(1024, 1024), batch_size=64, dropout=0.5, MAX_EPOCHS=100, dry_run=False, lr=0.0001, acf='relu',pred_acf='softmax',model_from_file=False,
        model_json="",
        model_w_file=""):
    #K.variable(lr, name='lr')
    opt_name = opt[0]
    opt = opt[1]()
    lrs_name = lrs[0]
    #model_name_save = f"{model_name}_detect_FULL__OPT_{opt_name}___LRS_{lrs_name}_final_1024"
    model_name_save = f"{model_name}_imagenet_FULL__OPT_{opt_name}___LRS_{lrs_name}_final_4096"

    print("Training for "+model_name_save)
    if dry_run:
        return
    """ big data set    
    TRAIN_DIR = "data/Train/flower_splits/train"
    VAL_DIR = "data/Train/flower_splits/val"
    TEST_DIR = "data/Train/flower_splits/test"
    TRAIN_DIR = "data/Train/detect_train"
    VAL_DIR = "data/Validation/detect_train"
    """
    TRAIN_DIR = "data/Train/imagenet12"
    VAL_DIR = "data/Validation/imagenet12"
    #TEST_DIR = "data/TrainBig/flower/test"

    img_width = 224
    img_height = 224
    img_channels = 3

    
    #datagen = ImageDataGenerator(rescale=1./255)
    train_datagen = ImageDataGenerator(
        rescale=1./256,
        horizontal_flip=True,
        vertical_flip=True,
        # shear_range=,
        zoom_range=0.05,
        width_shift_range=0.05,
        height_shift_range=0.05,
        rotation_range=15)

    val_datagen = ImageDataGenerator(rescale=1./256)
    #datagen = Augmentator._get_ImageDataGenerator()

    train_gen = train_datagen.flow_from_directory(
        directory=TRAIN_DIR,
        target_size=(img_width, img_height),
        color_mode='rgb',
        batch_size=batch_size,
        class_mode='categorical',
        shuffle=True,
        seed=seed
    )

    val_gen = val_datagen.flow_from_directory(
        directory=VAL_DIR,
        target_size=(img_width, img_height),
        color_mode='rgb',
        batch_size=batch_size,
        class_mode='categorical',
        shuffle=True,
        seed=seed
    )

    # train_gen.n gets number of samples. // => floor division
    TRAIN_STEP_SIZE = train_gen.n//batch_size
    VAL_STEP_SIZE = val_gen.n//batch_size

    # set up model
    # dataset as input - used to extract number of classes and inputsize
    if model_from_file:
        model = get_model_from(json_file_name=model_json,h5_file_name=model_w_file, acf=acf,pred_acf=pred_acf)
    else:
        model = get_model(model_name, dataset=train_gen,
                      dropout=dropout, fc_layers=fc_layers, acf=acf,pred_acf=pred_acf)
    model_json = model.to_json()
    with open(model_name_save+".json", "w") as json_file:
        json_file.write(model_json)

    model.compile(optimizer=opt, loss="categorical_crossentropy",
                  metrics=['accuracy'])
    #K.set_value(model.optimizer.lr, lr)
    lrs_obj = lrs[1]()
    callbacks_list = get_callbacks(model_name_save)
    callbacks_list.append(lrs_obj)

    fit_history = model.fit_generator(
        train_gen,
        steps_per_epoch=TRAIN_STEP_SIZE,
        validation_data=val_gen,
        validation_steps=VAL_STEP_SIZE,
        epochs=MAX_EPOCHS,
        callbacks=callbacks_list,
        verbose=verbose
    )

    print('Saving final weights...')
    model.save_weights("dl_weights/"+model_name_save +
                       timestamp+"final.h5", overwrite=True)

    # ----------- CREATING PLOTS AND SAVING DATA -----------
    DIR_TO_SAVE_IN = "results/plots/"+model_name+'/'+timestamp+'/'
    if not os.path.exists(DIR_TO_SAVE_IN):
        os.makedirs(DIR_TO_SAVE_IN)
    utils.createPlot(fit_history.history['acc'], modelName=model_name_save, unit="Accuracy",
                     title="Model accuracy for "+model_name, ylabel="Accuracy", xlabel="Epochs", folder=model_name+'/'+timestamp)
    utils.createPlot(fit_history.history['loss'], modelName=model_name_save, unit="Loss",
                     title="Model loss for "+model_name, ylabel="Loss", xlabel="Epochs", folder=model_name+'/'+timestamp)
    utils.createPlot(fit_history.history['lr'], modelName=model_name_save, unit="LearnRate", title="Model Learning Rate for " +
                     model_name, ylabel="Learning Rate", xlabel="Epochs", folder=model_name+'/'+timestamp)

    utils.saveData(fit_history.history['acc'],
                   filepath=DIR_TO_SAVE_IN+"Accuracy.P")
    utils.saveData(fit_history.history['loss'],
                   filepath=DIR_TO_SAVE_IN+"Loss.P")
    utils.saveData(fit_history.history['lr'],
                   filepath=DIR_TO_SAVE_IN+"LearnRate.P")
    lrs_obj = None
    opt = None
    model = None
    val_gen = None
    train_gen = None
    val_datagen = None
    train_datagen = None

    print('Done...')


if __name__ == '__main__':

    #def train(fix_W=16,OPT='SGD',fc_layers = [4096,4096],epochs=100,model_name="VGGsmallfix",scale_auto=True)
    
    
    
    lr = 1.1*1e-3#1
    min_lr = 3*3e-4#1
    OPTs = []

    WL = [16]#16
    OPT = ['SGD']
    SCALEAUTO = [True]#,False]#, False]
    #fc_layers = [1024,1024]
    fc_layers = [4096,4096]
    
    dropout = 0.0
    batch_size = 16
    max_epochs = 100

    # Reduce learning rate on plateau
    def reduce_lr(): return ReduceLROnPlateau(
        monitor='loss',
        #factor=0.50,#0.95, 0.98
        #patience=10,#5, 50
        factor=0.95,#0.95, 0.98
        patience=10,#5, 50
        min_lr=min_lr,
        verbose=verbose
    )

    static_lr = lambda : LearningRateScheduler(lambda epoch, lr: lr,1)

    for wl in WL:
        for opt in OPT:
            for sa in SCALEAUTO:
                W_fix_W = wl
                W_fix_I = 2

                X_fix_W = wl
                X_fix_I = 2



                if wl == 0:
                    if sa:
                        continue

                    if opt == 'SGD':
                        cur_opt = lambda : SGD(lr=lr)
                        cur_opt_name = 'SGD'
                    
                    cur_model_name = "VGG16"
                    acfObj = 'relu'
                    pred_acfObj = 'softmax'
                else:
                    if opt == 'SGD':
                        cur_opt = lambda : SGD_fix(lr=lr, fixW=W_fix_W, fixI=W_fix_I,autoscale=sa)
                        cur_opt_name = f"SGD_{wl}_{sa}"
                    
                    #cur_model_name = "VGGsmallfix"
                    cur_model_name = "VGG16fix"
                    acf = gen_reluFix(X_fix_W, X_fix_I)
                    acfObj = Activation(acf,name='relufix')
                    acfObj.__name__ = 'relufix'
                    get_custom_objects().update({'relufix' : acfObj})
                    pred_acf = gen_softmaxFix(X_fix_W, X_fix_I)
                    pred_acfObj = Activation(pred_acf,name='softmaxfix')
                    pred_acfObj.__name__ = 'softmaxfix'
                    get_custom_objects().update({'softmaxfix': pred_acfObj})

                magic(
                    lrs=("reduce_lr_loss",reduce_lr),
                    #lrs=("static",static_lr),
                    opt=(cur_opt_name, cur_opt),
                    #model_from_file=True,
                    #model_json="VGG16_flowers___OPT_fixSGD_Wfix_16W_fix_I_2X_fix_W_16X_fix_I_2___LRS_reduce_lr_fix.json",
                    #model_w_file="dl_weights/VGG16_flowers___OPT_fixSGD_Wfix_16W_fix_I_2X_fix_W_16X_fix_I_2___LRS_reduce_lr-epoch190-acc0.2201-loss3.1715-valacc0.1464-valloss3.4019.hdf5",
                    model_name=cur_model_name,
                    fc_layers=fc_layers,
                    batch_size=batch_size,
                    dropout=dropout,
                    MAX_EPOCHS=max_epochs,
                    dry_run=False,
                    acf=acfObj,pred_acf=pred_acfObj)
                

                
                
    
    

    

    #def fixAdam(): return Adam_fix(lr=lr, fixW=W_fix_W,
                                   #fixI=W_fix_I)  # ,name='adam_fix')

    #def fixSGD(): return SGD_fix(lr=lr, fixW=W_fix_W, fixI=W_fix_I)
    #CyclicAdam = lambda : Cyclical_Adam(lr =lr, beta_3 = 10**6)
    #Adam_ = lambda : Adam(lr=lr)
    #Sgd = lambda : SGD(lr=lr)

    # OPTs.append(("CyclicAdam",CyclicAdam))
    # OPTs.append(("Adam",Adam_))
    # OPTs.append(("Sgd",Sgd))

    #lr_Cyclical_cos = lambda : LearningRateScheduler(get_lr_scheduler_cyclical(lr,1,min_lr,15),1)
    #lr_triangular = lambda : LearningRateScheduler(get_lr_scheduler_triangular(lr, min_lr, 15),1)


    #LRSchedulers = []
    # LRSchedulers.append(("lr_Cyclical_cos",lr_Cyclical_cos))
    # LRSchedulers.append(("lr_triangular",lr_triangular))
    # LRSchedulers.append(("reduce_lr",reduce_lr))

    # models = []    #ResNet50 | DenseNet121 | MobileNetV2 | VGG19 |InceptionV3
    # models.append("VGG19")
    # models.append("ResNet50")

    # Hyperparameters
    
    

    # LRSchedulers[0]
    #itr = 0
    #magic(
    #    lrs=("reduce_lr_loss",reduce_lr),
    #    opt=("tmp_detect_fixSGD_Wfix_"+str(W_fix_W)+"W_fix_I_"+str(W_fix_I) +
    #         "X_fix_W_"+str(X_fix_W)+"X_fix_I_"+str(X_fix_I), fixSGD),
        #model_from_file=True,
        #model_json="VGG16_flowers___OPT_fixSGD_Wfix_16W_fix_I_2X_fix_W_16X_fix_I_2___LRS_reduce_lr_fix.json",
        #model_w_file="dl_weights/VGG16_flowers___OPT_fixSGD_Wfix_16W_fix_I_2X_fix_W_16X_fix_I_2___LRS_reduce_lr-epoch190-acc0.2201-loss3.1715-valacc0.1464-valloss3.4019.hdf5",
    #    model_name="VGGsmallfix",
    #    fc_layers=fc_layers,
    #    batch_size=batch_size,
    #    dropout=dropout,
    #    MAX_EPOCHS=max_epochs,
    #    dry_run=False,
    #    acf=acfObj,pred_acf=pred_acfObj)

    # for opt in OPTs:
    #    for model in models:
    #        for lrs in LRSchedulers:
    #            #if (getpass.getuser() == "GigaPC") == (itr % 3 == 0):
    #            magic(
    #                lrs=lrs,
    #                opt=opt,
    #                model_name=model,
    #                fc_layers=fc_layers,
    #                batch_size=batch_size,
    #                dropout=dropout,
    #                MAX_EPOCHS=max_epochs,
    #                dry_run=False)
    #            itr=itr+1
