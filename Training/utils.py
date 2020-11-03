# --- Utilities --- #
import matplotlib.pyplot as plt
import pickle, json, math, os, re
import numpy as np
import seaborn as sb
import pandas as pd

from scipy.signal import savgol_filter
from scipy.optimize import curve_fit, least_squares
from scipy.interpolate import UnivariateSpline

from keras.preprocessing.image import ImageDataGenerator, img_to_array, load_img

#To profile scripts run:
#   python -m cProfile -o output.pstats LunarLanderv2_DQN.py
#
# Visualize it with snakeviz
#   pip install snakeviz
# run it with :
#   snakeviz output.file

def createPlot(data, modelName="_", unit="", title="title", ylabel="ylabel", xlabel="xlabel", folder="default", save=True):
    plt.figure(figsize=(12,8))
    plt.plot(data, label=ylabel)
    
    plt.title(title)
    plt.ylabel(ylabel)
    plt.xlabel(xlabel)
    plt.xticks(np.arange(0, len(data)+1, len(data)/10))

    """ From R&D
    if unit=="Rewards" or unit=="Last100Rewards":
        x = list(range(len(data))) #0..1000
        #z = np.polyfit(x, data, 6)
        #p = np.poly1d(z)
        yhat = savgol_filter(data, 127, 3) #savgol better represents rewards - windowsize=127 to smooth
        plt.plot(x, yhat,"g--", label=unit+" fitted", linewidth=3)

        plt.yticks(np.arange(-400, 401, step=100))
        plt.ylim(bottom=-400, top=400)
        plt.axhline(y=200, xmin=0, xmax=len(data), label="avg_reward_to_win", color='r', linewidth=3)
    """
    plt.legend(loc="best")

    DIR_TO_SAVE_IN = "results\\plots\\"+folder
    if not os.path.exists(DIR_TO_SAVE_IN):
        os.makedirs(DIR_TO_SAVE_IN)

    if save:
        plt.savefig('results\\plots\\'+folder+"\\"+modelName+unit+'.png')
    plt.close()

#example
#utils.saveData(env.accuracy_list, DIR_TO_SAVE_IN+"\\"+MODEL_TO_SAVE+"Accuracy.P")
def saveData(data, filepath):
    with open(filepath, 'wb') as filehandle:
        pickle.dump(data, filehandle)

def loadData(filepath):
    with open(filepath, 'rb') as filehandle:
        return pickle.load(filehandle)

def saveDataJSON(data, filepath):
    with open(filepath, 'w', encoding="utf-8", newline="\r\n") as filehandle:
        json.dump(data, filehandle, indent=2, sort_keys=True, ensure_ascii=False)

#not fully tested
def loadDataJSON(filepath):
    with open(filepath, 'r', encoding="utf-8", newline="\r\n") as filehandle:
        json.load(filehandle)
