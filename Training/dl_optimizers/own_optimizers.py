from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import six
import copy

import numpy as np
import math
#from six.moves import zip
import tensorflow as tf
import keras.backend as K
#from tensorflow.keras.utils.generic_utils import serialize_keras_object
#from tensorflow.keras.utils.generic_utils import deserialize_keras_object
from keras.legacy import interfaces
from keras.layers import Activation
#from python.ops import array_ops


#class relufix(Activation):
    


from keras.optimizers import Optimizer
from keras.constraints import Constraint

def idenFix(x,fixW,fixI):
    scale = (2**((fixW-fixI)))
    fixmin = -(2**(fixW-1))
    fixmax = (2**(fixW-1))-1
    downscale = 1 / scale 
    with tf.get_default_graph().gradient_override_map({"Round": "Identity"}):
        upscale = tf.round(x*scale)
    #upscale = x*scale#
    clip = K.clip(upscale, fixmin , fixmax)
    downscaleval = clip * downscale
    return downscaleval

def gen_softmaxFix(fixW,fixI):
    return lambda x : K.softmax(idenFix(x, fixW, fixI))
    
def reluFix(x,fixW,fixI):
    scale = (2**((fixW-fixI)))
    fixmin = 0
    fixmax = (2**(fixW-1))-1
    downscale = 1 / scale 
    with tf.get_default_graph().gradient_override_map({"Round": "Identity"}):
        upscale = tf.round(x*scale)#K.round()
    clip = K.clip(upscale, fixmin , fixmax)
    downscaleval = clip * downscale
    return downscaleval

def gen_reluFix(fixW,fixI):
    return lambda x : reluFix(x, fixW, fixI)

class fixCon(Constraint):
    """MaxNorm weight constraint.
    Constrains the weightsdownscale = 1 / self.scale  incident to each hidden unit
    to have a norm less than or equal to a desired value.
    # Arguments
        max_value: the maximum norm for the incoming weights.
        axis: integer, axis along which to calculate weight norms.
            For instance, in a `Dense` layer the weight matrix
            has shape `(input_dim, output_dim)`,
            set `axis` to `0` to constrain each weight vector
            of length `(input_dim,)`.
            In a `Conv2D` layer with `data_format="channels_last"`,
            the weight tensor has shape
            `(rows, cols, input_depth, output_depth)`,
            set `axis` to `[0, 1, 2]`
            to constrain the weights of each filter tensor of size
            `(rows, cols, input_depth)`.
    # References
        - [Dropout: A Simple Way to Prevent Neural Networks from Overfitting](
           http://www.cs.toronto.edu/~rsalakhu/papers/srivastava14a.pdf)
    """

    def __init__(self, fixW=16,fixI=8,autoscale=True, axis=0):
        self.fixW = fixW
        self.fixI = fixI
        self.axis = axis
        self.scale = (2**((self.fixW-self.fixI)))
        self.min = -(2**(self.fixW-1))
        self.max = (2**(self.fixW-1))-1
        self.downscale = 1 / self.scale 
        self.autoscale=autoscale
        

    def __call__(self, w):
        if self.autoscale:
            upscale = w*self.scale
            autoscale_val = self.max / K.max(K.abs(upscale))

            upscale = K.round(upscale*autoscale_val)
            clip = K.clip(upscale, self.min , self.max)

            downscale = clip * self.downscale
            #downscale = downscale * self.fixscale(1/autoscale_val)
            downscale = downscale * K.round((1/autoscale_val)*(2**(14)))*(2**(-14))
        else:
            upscale = K.round(w*self.scale)
            clip = K.clip(upscale, self.min , self.max)
            downscale = clip * self.downscale
        return downscale

    def old__call__old(self, w):
        upscale = K.round(w*self.scale)
        clip = K.clip(upscale, self.min , self.max)
        downscale = clip * self.downscale
        return downscale

    def get_config(self):
        return {'max_value': self.max_value,
                'axis': self.axis}
class SGD_fix(Optimizer):
    """Stochastic gradient descent optimizer.
    Includes support for momentum,
    learning rate decay, and Nesterov momentum.
    # Arguments
        learning_rate: float >= 0. Learning rate.
        momentum: float >= 0. Parameter that accelerates SGD
            in the relevant direction and dampens oscillations.
        nesterov: boolean. Whether to apply Nesterov momentum.
    """

    def __init__(self, lr=0.01, momentum=0.001,
                 nesterov=False, fixW=16, fixI=8,autoscale=True, **kwargs):
        lr = kwargs.pop('lr', lr)
        self.initial_decay = kwargs.pop('decay', 0.0)
        super(SGD_fix, self).__init__(**kwargs)
        with K.name_scope(self.__class__.__name__):
            self.lr = K.variable(lr, name='lr')
            self.iterations = K.variable(0, dtype='int64', name='iterations')
            self.momentum = K.variable(momentum, name='momentum')
            self.decay = K.variable(self.initial_decay, name='decay')
        self.nesterov = nesterov
        self.fixW = fixW
        self.fixI = fixI
        self.fixcon = fixCon(fixW,fixI,autoscale)

    @interfaces.legacy_get_updates_support
    def get_updates(self, loss, params):
        grads = self.get_gradients(loss, params)
        self.updates = [K.update_add(self.iterations, 1)]

        lr = self.lr
        if self.initial_decay > 0:
            lr = lr * (1. / (1. + self.decay * K.cast(self.iterations,
                                                      K.dtype(self.decay))))
        # momentum
        shapes = [K.int_shape(p) for p in params]
        moments = [K.zeros(shape, name='moment_' + str(i))
                   for (i, shape) in enumerate(shapes)]
        self.weights = [self.iterations] + moments
        for p, g, m in zip(params, grads, moments):
            v = self.momentum * m - lr * g  # velocity
            self.updates.append(K.update(m, v))

            if self.nesterov:
                new_p = p + self.momentum * v - lr * g
            else:
                new_p = p + v

            # Apply constraints.
            if getattr(p, 'constraint', None) is not None:
                new_p = p.constraint(new_p)
                
            new_p = self.fixcon(new_p)
            self.updates.append(K.update(p, new_p))
        return self.updates

    def get_config(self):
        config = {'lr': float(K.get_value(self.lr)),
                  'momentum': float(K.get_value(self.momentum)),
                  'decay': float(K.get_value(self.decay)),
                  'nesterov': self.nesterov}
        base_config = super(SGD, self).get_config()
        return dict(list(base_config.items()) + list(config.items()))

class Adam_fix(Optimizer):
    """Adam fix optimizer.

    Default parameters follow those provided in the original paper.

    # Arguments
        lr: float >= 0. Learning rate.
        beta_1: float, 0 < beta < 1. Generally close to 1.
        beta_2: float, 0 < beta < 1. Generally close to 1.
        epsilon: float >= 0. Fuzz factor. If `None`, defaults to `K.epsilon()`.
        decay: float >= 0. Learning rate decay over each update.
        amsgrad: boolean. Whether to apply the AMSGrad variant of this
            algorithm from the paper "On the Convergence of Adam and
            Beyond".

    # References
        - [Adam - A Method for Stochastic Optimization]
          (https://arxiv.org/abs/1412.6980v8)
        - [On the Convergence of Adam and Beyond]
          (https://openreview.net/forum?id=ryQu7f-RZ)
    """

    def __init__(self, lr=0.001, beta_1=0.9, beta_2=0.999,
                 epsilon=None, decay=0., amsgrad=False, fixW=16, fixI=8,autoscale=True, **kwargs):
        super(Adam_fix, self).__init__(**kwargs)
        with K.name_scope(self.__class__.__name__):
            self.iterations = K.variable(0, dtype='int64', name='iterations')
            self.lr = K.variable(lr, name='lr')
            self.beta_1 = K.variable(beta_1, name='beta_1')
            self.beta_2 = K.variable(beta_2, name='beta_2')
            self.decay = K.variable(decay, name='decay')
        if epsilon is None:
            epsilon = K.epsilon()
        self.epsilon = epsilon
        self.initial_decay = decay
        self.amsgrad = amsgrad
        self.fixW = fixW
        self.fixI = fixI
        self.fixcon = fixCon(fixW,fixI,autoscale)

    @interfaces.legacy_get_updates_support
    def get_updates(self, loss, params):
        grads = self.get_gradients(loss, params)
        self.updates = [K.update_add(self.iterations, 1)]

        lr = self.lr
        if self.initial_decay > 0:
            lr = lr * (1. / (1. + self.decay * K.cast(self.iterations,
                                                      K.dtype(self.decay))))

        t = K.cast(self.iterations, K.floatx()) + 1
        lr_t = lr * (K.sqrt(1. - K.pow(self.beta_2, t)) /
                     (1. - K.pow(self.beta_1, t)))

        ms = [K.zeros(K.int_shape(p), dtype=K.dtype(p)) for p in params]
        vs = [K.zeros(K.int_shape(p), dtype=K.dtype(p)) for p in params]
        if self.amsgrad:
            vhats = [K.zeros(K.int_shape(p), dtype=K.dtype(p)) for p in params]
        else:
            vhats = [K.zeros(1) for _ in params]
        self.weights = [self.iterations] + ms + vs + vhats

        for p, g, m, v, vhat in zip(params, grads, ms, vs, vhats):
            m_t = (self.beta_1 * m) + (1. - self.beta_1) * g
            v_t = (self.beta_2 * v) + (1. - self.beta_2) * K.square(g)
            if self.amsgrad:
                print("Cyclical_Adam - doing something")
                vhat_t = K.maximum(vhat, v_t)
                p_t = p - lr_t * m_t / (K.sqrt(vhat_t) + self.epsilon)
                self.updates.append(K.update(vhat, vhat_t))
            else:
                p_t = p - lr_t * m_t / (K.sqrt(v_t) + self.epsilon)

            self.updates.append(K.update(m, m_t))
            self.updates.append(K.update(v, v_t))
            new_p = p_t

            # Apply constraints.
            if getattr(p, 'constraint', None) is not None:
                new_p = p.constraint(new_p)
            
            new_p = self.fixcon(new_p)
            self.updates.append(K.update(p, new_p))
        return self.updates

    def get_config(self):
        config = {'lr': float(K.get_value(self.lr)),
                  'beta_1': float(K.get_value(self.beta_1)),
                  'beta_2': float(K.get_value(self.beta_2)),
                  'decay': float(K.get_value(self.decay)),
                  'epsilon': self.epsilon,
                  'amsgrad': self.amsgrad,
                  'fixW': self.fixW,
                  'fixI': self.fixI}
        base_config = super(Adam_fix, self).get_config()
        return dict(list(base_config.items()) + list(config.items()))



class Cyclical_Adam(Optimizer):
    """Adam test optimizer.

    Default parameters follow those provided in the original paper.

    # Arguments
        lr: float >= 0. Learning rate.
        beta_1: float, 0 < beta < 1. Generally close to 1.
        beta_2: float, 0 < beta < 1. Generally close to 1.
        epsilon: float >= 0. Fuzz factor. If `None`, defaults to `K.epsilon()`.
        decay: float >= 0. Learning rate decay over each update.
        amsgrad: boolean. Whether to apply the AMSGrad variant of this
            algorithm from the paper "On the Convergence of Adam and
            Beyond".

    # References
        - [Adam - A Method for Stochastic Optimization]
          (https://arxiv.org/abs/1412.6980v8)
        - [On the Convergence of Adam and Beyond]
          (https://openreview.net/forum?id=ryQu7f-RZ)
    """

    def __init__(self, lr=0.001, beta_1=0.9, beta_2=0.999,
                 epsilon=None, decay=0., amsgrad=False, beta_3=10**6, minThres=True, **kwargs):
        super(Cyclical_Adam, self).__init__(**kwargs)
        with K.name_scope(self.__class__.__name__):
            self.iterations = K.variable(0, dtype='int64', name='iterations')
            self.lr = K.variable(lr, name='lr')
            self.beta_1 = K.variable(beta_1, name='beta_1')
            self.beta_2 = K.variable(beta_2, name='beta_2')
            self.decay = K.variable(decay, name='decay')
        if epsilon is None:
            epsilon = K.epsilon()
        self.epsilon = epsilon
        self.initial_decay = decay
        self.amsgrad = amsgrad
        self.beta_3 = beta_3
        self.minThres = minThres
        print("Cyclical_Adam - init - done")

    @interfaces.legacy_get_updates_support
    def get_updates(self, loss, params):
        grads = self.get_gradients(loss, params)
        self.updates = [K.update_add(self.iterations, 1)]

        lr = self.lr
        if self.initial_decay > 0:
            lr = lr * (1. / (1. + self.decay * K.cast(self.iterations,
                                                      K.dtype(self.decay))))

        t = K.cast(self.iterations, K.floatx()) + 1
        lr_t = lr * (K.sqrt(1. - K.pow(self.beta_2, t)) /
                     (1. - K.pow(self.beta_1, t)))

        ms = [K.zeros(K.int_shape(p), dtype=K.dtype(p)) for p in params]
        vs = [K.zeros(K.int_shape(p), dtype=K.dtype(p)) for p in params]
        if self.amsgrad:
            vhats = [K.zeros(K.int_shape(p), dtype=K.dtype(p)) for p in params]
        else:
            vhats = [K.zeros(1) for _ in params]
        self.weights = [self.iterations] + ms + vs + vhats

        for p, g, m, v, vhat in zip(params, grads, ms, vs, vhats):
            m_t = (self.beta_1 * m) + (1. - self.beta_1) * g
            v_t = (self.beta_2 * v) + (1. - self.beta_2) * K.square(g)

            if self.minThres:
                pred = v_t > self.beta_3
                v_t = array_ops.where(pred, array_ops.zeros_like(v_t),v_t)

            if self.amsgrad:
                vhat_t = K.maximum(vhat, v_t)
                p_t = p - lr_t * m_t / (K.sqrt(vhat_t) + self.epsilon)
                self.updates.append(K.update(vhat, vhat_t))
            else:
                p_t = p - lr_t * m_t / (K.sqrt(v_t) + self.epsilon)
                
                
                
                

            self.updates.append(K.update(m, m_t))
            self.updates.append(K.update(v, v_t))
            new_p = p_t

            # Apply constraints.
            if getattr(p, 'constraint', None) is not None:
                new_p = p.constraint(new_p)

            self.updates.append(K.update(p, new_p))
        return self.updates

    def get_config(self):
        config = {'lr': float(K.get_value(self.lr)),
                  'beta_1': float(K.get_value(self.beta_1)),
                  'beta_2': float(K.get_value(self.beta_2)),
                  'decay': float(K.get_value(self.decay)),
                  'epsilon': self.epsilon,
                  'amsgrad': self.amsgrad,
                  'beta_3': self.beta_3,
                  'minThres': self.minThres}
        base_config = super(Cyclical_Adam, self).get_config()
        return dict(list(base_config.items()) + list(config.items()))


def get_lr_scheduler_cyclical(start_lr,max_lr_rel,min_lr_rel, interval_N):
    lr_scheduler = lambda epoch, lr: start_lr*(((max_lr_rel-min_lr_rel)*((math.cos((math.pi)*(epoch % interval_N)/interval_N))+1)/2) + min_lr_rel)
    return lr_scheduler

def _cycle(epoch,stepSize):
    return math.floor(1.0 + epoch/(2*stepSize))

def _x(epoch,stepSize):
    return np.abs(epoch/stepSize - 2*_cycle(epoch,stepSize) + 1)

def get_lr_scheduler_triangular(start_lr,min_lr, stepSize):
    lr_scheduler = lambda epoch, lr: min_lr + (start_lr - min_lr)*np.max([0, (1-_x(epoch,stepSize))])
    return lr_scheduler
