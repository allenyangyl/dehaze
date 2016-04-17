import numpy as np
import matplotlib.pyplot as plt
from skimage.transform import resize

# Make sure that caffe is on the python path:
caffe_root = '../../caffe/'  # this file is expected to be in {caffe_root}/examples
import sys
sys.path.insert(0, caffe_root + 'python')

import caffe
import time

# Image file name
test_file = '9.jpg'
directory = '/home/yiliny1/Dehaze/data/'

# Set up caffe model
caffe.set_device(0)
caffe.set_mode_gpu()
net = caffe.Net('deploy.prototxt',
                'models/model_iter_300000.caffemodel',
                caffe.TEST)

# Pre-processing
transformer = caffe.io.Transformer({'data': net.blobs['data'].data.shape})
transformer.set_transpose('data', (2,0,1))  # move image channels to outermost dimension
transformer.set_raw_scale('data', 255)      # rescale from [0, 1] to [0, 255]
transformer.set_mean('data', np.array([127.5, 127.5, 127.5]))            # subtract the dataset-mean value in each channel
transformer.set_channel_swap('data', (2,1,0))  # swap channels from RGB to BGR

# Load image
t0 = time.time()
image_raw = caffe.io.load_image(directory + test_file)
shape = image_raw.shape
image = transformer.preprocess('data', image_raw)

# Input image into CNN
net.blobs['data'].data[0] = image
out = net.forward()
transmission = net.blobs['bn3'].data[0]

# Process transmission 
transmission = np.transpose(transmission, (1,2,0))
transmission[transmission < 0.1] = 0.1
transmission = np.repeat(transmission, 3, axis=2)
transmission = resize(transmission, (shape[0], shape[1]))
A = 0.9

# Calculate dehazed image
radiance = (image_raw - A * (1 - transmission)) / transmission
print(np.amax(radiance))
print(np.amin(radiance))
radiance[radiance > 1] = 1
radiance[radiance < 0] = 0

# Save results
plt.imsave('../trans.png', transmission, vmin=0, vmax=1)
plt.imsave('../rad.png', radiance, vmin=0, vmax=1)
t1 = time.time()
print 'calculating time: '
print t1 - t0
