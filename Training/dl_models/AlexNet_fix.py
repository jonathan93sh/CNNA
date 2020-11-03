"""VGG16 model for Keras.

# Reference

- [Very Deep Convolutional Networks for Large-Scale Image Recognition](
    https://arxiv.org/abs/1409.1556)

"""
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import os

from keras_applications import get_submodules_from_kwargs
from keras_applications import imagenet_utils
from keras_applications.imagenet_utils import decode_predictions
from keras_applications.imagenet_utils import _obtain_input_shape

import keras.backend as backend
import keras.layers as layers
import keras.models as models
import keras.utils as keras_utils

preprocess_input = imagenet_utils.preprocess_input

WEIGHTS_PATH = ('http://files.heuritech.com/weights/alexnet_weights.h5')
WEIGHTS_PATH_NO_TOP = ('http://files.heuritech.com/weights/alexnet_weights.h5')

def AlexNet_fix(include_top=True,
          weights='imagenet',
          input_tensor=None,
          input_shape=None,
          pooling=None,
          classes=1000,
          acf='relufix',
          acfpred='softmaxfix',
          **kwargs):
    """Instantiates the AlexNet architecture using fixed-point.

    Optionally loads weights pre-trained on ImageNet.
    Note that the data format convention used by the model is
    the one specified in your Keras config at `~/.keras/keras.json`.

    # Arguments
        include_top: whether to include the 3 fully-connected
            layers at the top of the network.
        weights: one of `None` (random initialization),
              'imagenet' (pre-training on ImageNet),
              or the path to the weights file to be loaded.
        input_tensor: optional Keras tensor
            (i.e. output of `layers.Input()`)
            to use as image input for the model.
        input_shape: optional shape tuple, only to be specified
            if `include_top` is False (otherwise the input shape
            has to be `(224, 224, 3)`
            (with `channels_last` data format)
            or `(3, 224, 224)` (with `channels_first` data format).
            It should have exactly 3 input channels,
            and width and height should be no smaller than 32.
            E.g. `(200, 200, 3)` would be one valid value.
        pooling: Optional pooling mode for feature extraction
            when `include_top` is `False`.
            - `None` means that the output of the model will be
                the 4D tensor output of the
                last convolutional block.
            - `avg` means that global average pooling
                will be applied to the output of the
                last convolutional block, and thus
                the output of the model will be a 2D tensor.
            - `max` means that global max pooling will
                be applied.
        classes: optional number of classes to classify images
            into, only to be specified if `include_top` is True, and
            if no `weights` argument is specified.

    # Returns
        A Keras model instance.

    # Raises
        ValueError: in case of invalid argument for `weights`,
            or invalid input shape.
    """
    #acf='relufix'
    #acfpred='softmaxfix'
    #backend, layers, models, keras_utils = get_submodules_from_kwargs(kwargs)

    if not (weights in {'imagenet', None} or os.path.exists(weights)):
        raise ValueError('The `weights` argument should be either '
                         '`None` (random initialization), `imagenet` '
                         '(pre-training on ImageNet), '
                         'or the path to the weights file to be loaded.')

    if weights == 'imagenet' and include_top and classes != 1000:
        raise ValueError('If using `weights` as `"imagenet"` with `include_top`'
                         ' as true, `classes` should be 1000')
    # Determine proper input shape
    input_shape = _obtain_input_shape(input_shape,
                                      default_size=224,
                                      min_size=32,
                                      data_format=backend.image_data_format(),
                                      require_flatten=include_top,
                                      weights=weights)

    if input_tensor is None:
        img_input = layers.Input(shape=input_shape)
    else:
        if not backend.is_keras_tensor(input_tensor):
            img_input = layers.Input(tensor=input_tensor, shape=input_shape)
        else:
            img_input = input_tensor
    # Block 1
    x = layers.Conv2D(96, (11, 11),
                      activation=acf,
                      strides=(4, 4),
                      padding='valid',
                      name='block1_conv1')(img_input)

    x = layers.MaxPooling2D(pool_size=(2, 2), 
                            name='block1_pool')(x)

    # Block 2
    x = layers.Conv2D(256, (5, 5),
                      activation=acf,
                      padding='same',
                      name='block2_conv1')(x)
    
    x = layers.MaxPooling2D(pool_size=(2, 2), 
                            name='block2_pool')(x)

    # Block 3
    x = layers.Conv2D(384, (3, 3),
                      activation=acf,
                      padding='same',
                      name='block3_conv1')(x)
    # Block 4
    x = layers.Conv2D(384, (3, 3),
                      activation=acf,
                      padding='same',
                      name='block4_conv1')(x)
    # Block 5
    x = layers.Conv2D(256, (3, 3),
                      activation=acf,
                      padding='same',
                      name='block5_conv1')(x)
    
    x = layers.MaxPooling2D(pool_size=(2, 2), 
                            name='block5_pool')(x)


    if include_top:
        # Classification block
        x = layers.Flatten(name='flatten')(x)
        x = layers.Dense(4096, activation=acf, name='fc1')(x)
        x = layers.Dense(4096, activation=acf, name='fc2')(x)
        x = layers.Dense(classes, activation=acfpred, name='predictions')(x)
    else:
        if pooling == 'avg':
            x = layers.GlobalAveragePooling2D()(x)
        elif pooling == 'max':
            x = layers.GlobalMaxPooling2D()(x)

    # Ensure that the model takes into account
    # any potential predecessors of `input_tensor`.
    if input_tensor is not None:
        inputs = keras_utils.get_source_inputs(input_tensor)
    else:
        inputs = img_input
    # Create model.
    model = models.Model(inputs, x, name='AlexNet')

    # Load weights.
    if weights == 'imagenet':
        if include_top:
            weights_path = keras_utils.get_file(
                'alexnet_weights.h5',
                WEIGHTS_PATH)
        else:
            weights_path = keras_utils.get_file(
                'alexnet_weights.h5',
                WEIGHTS_PATH_NO_TOP)
        model.load_weights(weights_path)
        if backend.backend() == 'theano':
            keras_utils.convert_all_kernels_in_model(model)
    elif weights is not None:
        model.load_weights(weights)

    return model

#Instantiates the AlexNet architecture.
def AlexNet(include_top=True, weights=None,  input_shape=None):
    
    model = AlexNet_fix(include_top=include_top,
                        weights=weights, 
                        input_shape=input_shape,
                        acf='relu',
                        acfpred='softmax')
    return model