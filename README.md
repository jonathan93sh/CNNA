# Convolutinal Neural Network Accelerator (CNNA)
A scalable and efficient convolutional neural network accelerator using HLS for a System on Chip design

# Abstract:
The source code concerns a configurable Convolutional Neural Network Accelerator (CNNA) for a System on Chip design (SoC). 
The goal was to accelerate inference of different deep learning networks on an embedded SoC platform. 
The CNNA has a scalable architecture which uses High Level Synthesis (HLS) and SystemC for the hardware accelerator. 
It is able to accelerate any Convolutional Neural Network (CNN) exported from Python and supports a combination of convolutional, max-pooling, and fully connected layers. 
A training method with fixed-point quantized weights is proposed and presented in the paper with link below. 
The CNNA is template-based, enabling it to scale for different targets of the Xilinx Zynq platform. 
This approach enables design space exploration, which makes it possible to explore several configurations of the CNNA during C- and RTL-simulation, 
fitting it to the desired platform and model. The CNN VGG16 was used to test the solution on a Xilinx Ultra96 board using PYNQ. 

# Paper
https://arxiv.org/abs/2004.13075

# Development Tools
This code requires a development platform with Linux, Python and Xilinx Vivado 2019.1 installed.
The target platform is Xilinx Ultra96v2 running PYNQ version 2.4. 

# Directories
- Training: contains the Python code to train fixed-point CNN models in Keras. The trained model is saved in Training/json (*.json) and the weights in Training/weights (*.h5).
- PreProcessing: contains the Python code to perform preprocessing of the model (*.json) and weights (*.h5).
- PYNQ: contains the Python library (NNAccelerator.py) and jupyter notebooks for inference on the target platform (Xilinx Ultra96v2 with PYNQ)
- src: contains the SystemC source code for the IP Core (CNNA)
- src/jupyterlab/HEB.py: Python script to build the bit file stored in src/IP_catalog/[IP core]/bitfiles



