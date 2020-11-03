# data augmentation...
from keras.preprocessing.image import ImageDataGenerator, img_to_array, load_img
import scipy.io as sio
import os
from shutil import copy
# conda install scikit-learn, sklearn, scipy
from sklearn.model_selection import train_test_split
# install with pip install split-folders ||| https://github.com/jfilter/split-folders
#import split_folders

img_width, img_height = 224, 224

train_data_dir = "data\\Train\\flower_imgs"
#validation_data_dir = "data\\Flowers102\\val"

"""
def get_train_gen():
    train_generator = train_datagen.flow_from_directory(
    train_data_dir,
    target_size = (img_height, img_width),
    class_mode = "categorical")
    return train_generator
"""

# Just copy all images raw into IMG_LOCATION folder and run script - currently only needed for FLOWERS

def organize_imgs_detect(labels, IMG_SOURCE="data/raw_imgs", IMG_DESTINATION="data/Train/flower_imgs"):
    for i in range(0, len(labels)):
        source_name = '%s/image%d.jpg' % (IMG_SOURCE, i+1)
        if os.path.exists(source_name):
            dest_name = '%s/%s/image_%05d.jpg' % (
                IMG_DESTINATION, labels[i], i+1)

            TARGET_DIR = os.path.dirname(dest_name)
            if not os.path.exists(TARGET_DIR):
                os.makedirs(TARGET_DIR)
            # copy files from source and order them
            copy(source_name, dest_name)
            # os.rename(source_name, dest_name)  #could also just move them
        else:
            print("OOPS in organize - Check IMG_LOCATION")

    print("Done organizing in: {}".format(IMG_DESTINATION))

def organize_imgs(labels, IMG_SOURCE="data/raw_imgs", IMG_DESTINATION="data/Train/flower_imgs"):
    for i in range(0, len(labels)):
        source_name = '%s/image_%05d.jpg' % (IMG_SOURCE, i+1)
        if os.path.exists(source_name):
            dest_name = '%s/%s/image_%05d.jpg' % (
                IMG_DESTINATION, labels[i], i+1)

            TARGET_DIR = os.path.dirname(dest_name)
            if not os.path.exists(TARGET_DIR):
                os.makedirs(TARGET_DIR)
            # copy files from source and order them
            copy(source_name, dest_name)
            # os.rename(source_name, dest_name)  #could also just move them
        else:
            print("OOPS in organize - Check IMG_LOCATION")

    print("Done organizing in: {}".format(IMG_DESTINATION))


class Augmentator:
    def __init__(self):
        pass

    # Returns ImageDataGenerator - define image augmentation here
    def _get_ImageDataGenerator(self):
        img_gen = ImageDataGenerator(
            #rescale = 1./255,
            horizontal_flip=True,
            vertical_flip=True,
            shear_range=10,
            zoom_range=0.2,
            width_shift_range=0.2,
            height_shift_range=0.2,
            rotation_range=360)
        return img_gen

    def do_augmentation(self, DIR_TO_AUGMENT, imgs_pr_class=250, seed=69):
        img_gen = self._get_ImageDataGenerator()
        class_dirs = os.listdir(DIR_TO_AUGMENT)

        for class_dir in sorted(class_dirs):
            img_names = os.listdir(os.path.join(DIR_TO_AUGMENT, class_dir))
            img_count = len(img_names)
            augment_ratio = round(imgs_pr_class / img_count)

            print("Class ", class_dir, "has ", img_count, " images | Augment ratio: ",
                  augment_ratio, " | Final amount of images: ", img_count*augment_ratio)

            DEST_DIR = os.path.join(DIR_TO_AUGMENT, class_dir)
            if not os.path.isdir(DEST_DIR):
                os.mkdir(DEST_DIR)
            for img_name in sorted(img_names):
                if len(img_name.split('_')) > 2:  # skip augs
                    print(' Skipping {}'.format(img_name))

                print("Gen imgs for: "+img_name)
                img = load_img(os.path.join(
                    DIR_TO_AUGMENT, class_dir, img_name))
                x = img_to_array(img)
                x = x.reshape((1,) + x.shape)
                prefix = os.path.splitext(img_name)[0]+'_aug'

                i = 0
                for batch in img_gen.flow(x,
                                          seed=seed,
                                          batch_size=1,
                                          save_to_dir=DEST_DIR,
                                          save_prefix=prefix,
                                          save_format='jpg'):
                    i += 1
                    if i > augment_ratio:  # when a certain amount of augmented images have been made end making for that class
                        break

    # cleans all augmented imgs from a folder if standard name is: 'image_10192.jpg'
    def clean(self, DIR_TO_CLEAN):
        i = 0
        class_dirs = os.listdir(DIR_TO_CLEAN)
        for class_dir in sorted(class_dirs):
            img_names = os.listdir(os.path.join(DIR_TO_CLEAN, class_dir))
            for img in sorted(img_names):
                if len(img.split('_')) > 2:  # remove augmented images 'image_00001_aug_xxxx'
                    os.remove(os.path.join(DIR_TO_CLEAN, class_dir, img))
                    i += 1

        print("Cleaning done, imgs removed:", i)


def getlabels(labelfile):
    labels = []
    with open(labelfile) as fp:
        for line in fp:
            labels.append(int(line))
    return labels

if __name__ == "__main__":
    #TRAIN_DIR = "data\\CUB-200\\files.txt"

    #f = open(TRAIN_DIR,"r")
    # if f.mode == "r":
    #    imagelabels = f.read()

    #LABELS_DIR = "data/Flowers102/imagelabels"
    #SOURCE_DIR = "data/raw_imgs"
    #TRAIN_DIR = "data/Train/flower_imgs_noaug"
    #imagelabels = sio.loadmat(LABELS_DIR)
    #tmp_lbls = imagelabels['labels']
    #train_labels = tmp_lbls[0]

    #X_train, X_test, y_train, y_test = train_test_split(X, train_labels, test_size=0.33, random_state=69)

    #print("Flower labels loaded, count:{}".format(len(train_labels)))
    # organize_imgs(train_labels, IMG_SOURCE=SOURCE_DIR, IMG_DESTINATION=TRAIN_DIR) #copy raw imgs and order them from SOURCE => in DEST
    # Run the image augmentation

    """
    augmentator = Augmentator()
    augmentator.clean(DIR_TO_CLEAN=TRAIN_DIR) #remove all previous imgs
    augmentator.do_augmentation(DIR_TO_AUGMENT=TRAIN_DIR, imgs_pr_class=250) #Do augmentation on DIR_TO_AUGMENT
    """
    #organize_imgs(train_labels, SOURCE_DIR, TRAIN_DIR)
    #input_fold = TRAIN_DIR
    #output_fold = "data/TrainBig/flower"
    train_labels = "data/detect/Train/trainLbls.txt"
    train_labels = getlabels(train_labels)# sio.loadmat(train_labels)
    print("Detect train labels loaded, count:{}".format(len(train_labels)))
    train_source = "data/detect/Train/TrainImages"
    train_dst = "data/Train/detect_train"
    organize_imgs_detect(train_labels,train_source,train_dst)

    val_labels = "data/detect/Validation/valLbls.txt"
    val_labels = getlabels(val_labels)# sio.loadmat(val_labels)
    print("Detect val labels loaded, count:{}".format(len(val_labels)))
    val_source = "data/detect/Validation/ValidationImages"
    val_dst = "data/Validation/detect_train"
    organize_imgs_detect(val_labels,val_source,val_dst)
    

    # Split val/test with a fixed number of items e.g. 100 for each set.
    # To only split into training and validation set, use a single number to `fixed`, i.e., `10`.
    #split_folders.fixed(input_fold, output=output_fold, seed=69, fixed=(
    #    10, 3), oversample=False)  # default values
