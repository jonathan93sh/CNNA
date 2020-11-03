#from tensorflow.keras import backend as k
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

from keras.models import Sequential, Model, model_from_json, load_model
from keras.layers import Dense, Dropout
from keras.layers import Flatten, MaxPooling2D, GlobalAveragePooling2D, Conv2D
#from keras.applications import ResNet50, DenseNet121, VGG19, MobileNetV2, InceptionV3
#from keras.applications import ResNet50, DenseNet121, VGG19, MobileNetV2, InceptionV3, VGG16
from keras.applications import ResNet50, DenseNet121, VGG19, InceptionV3, VGG16

import dl_models.vgg16_fix as vggfix
import dl_models.AlexNet_fix as AlexNetfix

from keras import utils



def get_model_from(json_file_name,h5_file_name, acf='relu',pred_acf='softmax'):
    json_file = open(json_file_name, 'r')
    loaded_model_json = json_file.read()
    json_file.close()
    loaded_model = model_from_json(loaded_model_json)
    loaded_model.load_weights(h5_file_name)
    
    for layer in loaded_model.layers[:-1]:
        #layer.trainable = False
        layer.activation = acf
    
    loaded_model.layers[-1].activation = pred_acf
    return loaded_model



def get_model(model_name, dataset, dropout, fc_layers=(1024, 1024), acf='relu',pred_acf='softmax'):
    #ResNet50 | DenseNet121 | MobileNetV2 | VGG19 | InceptionV3

    print("Getting model... ", model_name)

    weights = 'imagenet'

    if model_name == "ResNet50":
        base_model = ResNet50(
            weights=weights, include_top=False, input_shape=dataset.image_shape)
    elif model_name == "DenseNet121":
        base_model = DenseNet121(
            weights=weights, include_top=False, input_shape=dataset.image_shape)
    #elif model_name == "MobileNetV2":
    #    base_model = MobileNetV2(
    #        weights=weights, include_top=False, input_shape=dataset.image_shape)
    elif model_name == "VGG19":
        base_model = VGG19(weights=weights, include_top=False,
                           input_shape=dataset.image_shape)
    elif model_name == "VGG16":
        base_model = VGG16(weights=weights, include_top=False,
                           input_shape=dataset.image_shape)
    elif model_name == "VGG16fix":
        base_model = vggfix.VGG16_fix(weights=weights, include_top=False,
                           input_shape=dataset.image_shape)
    elif model_name == "AlexNetfix":
        base_model = AlexNetfix.AlexNet_fix(weights=None, include_top=False,
                           input_shape=dataset.image_shape)
    elif model_name == "AlexNet":
        base_model = AlexNetfix.AlexNet(weights=None, include_top=False,
                           input_shape=dataset.image_shape)
    elif model_name == "VGGsmallfix":
        base_model = vggfix.VGG_small_fix( include_top=False,
                           input_shape=dataset.image_shape)
    elif model_name == "VGG7":
        tmp_base_model = VGG16(weights=weights, include_top=False,
                           input_shape=dataset.image_shape)
        #tmp_base_model.layers = tmp_base_model.layers[:-5]
        #tmp_base_model.outputs = [tmp_base_model.layers[-1].output]
        base_model = Model(inputs=tmp_base_model.input, outputs=tmp_base_model.layers[6].output)

    elif model_name == "InceptionV3":
        base_model = InceptionV3(
            weights=weights, include_top=False, input_shape=dataset.image_shape)

    else:
        print("Wrong input argument, use either: ResNet50 or DenseNet121...")

    FC_LAYERS = fc_layers

    finetuned_model = build_finetuned_model(
        base_model, dropout=dropout, fc_layers=FC_LAYERS, num_classes=dataset.num_classes, acf=acf,pred_acf=pred_acf)

    finetuned_model.summary()

    return finetuned_model


def build_finetuned_model(base_model, dropout, fc_layers, num_classes, acf='relu',pred_acf='softmax'):
    # Freeze the imported layers' weights

    #for i in range(len(base_model.layers)):
    #    base_model.layers[i].activation = acf
    #base_model.layers[0]
    #for layer in base_model.layers:
    #    #layer.trainable = False
    #    layer.activation = acf
    
    #base_model.save('tmp.h5')
    #base_model = load_model('tmp.h5',compile=False)

    #base_model = utils.apply_modifications(base_model)

    x = base_model.output

    x = Flatten()(x)
    #x = GlobalAveragePooling2D()(x)

    for fc in fc_layers:
        # New FC layer, random init
        # weight kernel_initalizer="xavier"
        x = Dense(fc, activation=acf)(x)
        #x = Dropout(dropout)(x)

    # New softmax layer
    predictions = Dense(num_classes, activation=pred_acf)(x)#'softmax')(x)

    finetune_model = Model(inputs=base_model.input, outputs=predictions)

    return finetune_model
