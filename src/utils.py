import cv2
import os

def read_img(path):
    """Given a path to an image file, returns a cv2 array

    str -> np.ndarray"""
    if os.path.isfile(path):
        return cv2.imread(path)
    else:
        raise ValueError('Path provided is not a valid file: {}'.format(path))