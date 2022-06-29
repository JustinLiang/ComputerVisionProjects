from PIL import Image, ImageDraw
from matplotlib.pyplot import imshow
import numpy as np
import math
from scipy import signal
import ncc

templateWidth = 20.0

def MakePyramid(image, minsize):

    """

    :rtype: Image
    """
    im = Image.open(image)
    pyramidList = [im]

    while im.width > minsize and im.height > minsize:
        im = im.resize((int(im.width*0.75),int(im.height*0.75)), Image.BICUBIC)
        pyramidList.append(im)

    return pyramidList

def ShowPyramid(pyramid):

    if(len(pyramid) == 0): return

    width = 0
    height = pyramid[0].height

    for im in pyramid:
        width += im.width

    pyramidImage = Image.new("L", (width, height))
    offset_x = 0
    offset_y = 0

    for im in pyramid:
        pyramidImage.paste(im, (offset_x, offset_y))
        offset_x += im.width

    pyramidImage.show()

# pyramid = MakePyramid("faces/mehtab.jpg", 1)
# ShowPyramid(pyramid)

def FindTemplate(pyramid, template, threshold):

    newTemplateWidth = templateWidth;
    newTemplateHeight = templateWidth/template.width*template.height;

    if template.width > templateWidth:
        template = template.resize((int(newTemplateWidth),int(newTemplateHeight)), Image.BICUBIC)

    outputImage = pyramid[0];   # Get the original image, this is the one you draw rectangles on
    outputImage = outputImage.convert('RGB')

    for index, im in enumerate(pyramid):
        nccImage = ncc.normxcorr2D(im, template)       # Get the normalized correlation of the template onto the im
        rectWidth = newTemplateWidth / (0.75 ** index)  # Update template rectangle size
        rectHeight = newTemplateHeight / (0.75 ** index) # Update template rectangle size
        for row in range(nccImage.shape[0]):
            for col in range(nccImage.shape[1]):
                if(nccImage[row][col] > threshold):
                    scaledBackCol = col*(1.333**index)
                    scaledBackRow = row*(1.333**index)
                    draw = ImageDraw.Draw(outputImage)
                    draw.rectangle([scaledBackCol-rectWidth/2, scaledBackRow-rectHeight/2, scaledBackCol+rectWidth/2, scaledBackRow+rectHeight/2], fill=None, outline="red")
                    del draw

    outputImage.show()

pyramid = MakePyramid("faces/judybats.jpg", 1)
template = Image.open("faces/template.jpg")
FindTemplate(pyramid, template, 0.635)

# nccImage = ncc.normxcorr2D(template, template)
# nccImage = Image.fromarray(nccImage)
# nccImage.show()
