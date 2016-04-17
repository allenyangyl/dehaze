import numpy as np
import matplotlib.pyplot as plt
from skimage.transform import resize

# Make sure that caffe is on the python path:
caffe_root = '../../caffe/'  # this file is expected to be in {caffe_root}/examples
import sys
sys.path.insert(0, caffe_root + 'python')

import caffe
import time

t0 = time.time()
test_file = '9.jpg'
directory = '/home/yiliny1/Dehaze/data/'

caffe.set_device(0)
caffe.set_mode_gpu()
#net = caffe.Net('/home/yiliny1/caffe/models/bvlc_reference_caffenet/deploy.prototxt', 
#		'/home/yiliny1/caffe/models/bvlc_reference_caffenet/bvlc_reference_caffenet.caffemodel', 
#		caffe.TEST)
net = caffe.Net('deploy.prototxt',
                'models/model_iter_300000.caffemodel',
                caffe.TEST)

transformer = caffe.io.Transformer({'data': net.blobs['data'].data.shape})
transformer.set_transpose('data', (2,0,1))  # move image channels to outermost dimension
transformer.set_raw_scale('data', 255)      # rescale from [0, 1] to [0, 255]
transformer.set_mean('data', np.array([127.5, 127.5, 127.5]))            # subtract the dataset-mean value in each channel
transformer.set_channel_swap('data', (2,1,0))  # swap channels from RGB to BGR

image_raw = caffe.io.load_image(directory + test_file)
shape = image_raw.shape
print image_raw
image = transformer.preprocess('data', image_raw)
net.blobs['data'].data[0] = image
out = net.forward()
transmission = net.blobs['bn3'].data[0]
print(np.amax(transmission))
print(np.amin(transmission))
transmission = np.transpose(transmission, (1,2,0))
#transmission[transmission > 0.9] = 0.9
transmission[transmission < 0.1] = 0.1
transmission = np.repeat(transmission, 3, axis=2)
#transmission = cv2.resize(transmission, (shape[0], shape[1]))
transmission = resize(transmission, (shape[0], shape[1]))
radiance = (image_raw - 0.9 * (1 - transmission)) / transmission
print(np.amax(radiance))
print(np.amin(radiance))
radiance[radiance > 1] = 1
radiance[radiance < 0] = 0
plt.imsave('../trans.png', transmission, vmin=0, vmax=1)
plt.imsave('../rad.png', radiance, vmin=0, vmax=1)
t1 = time.time()
print 'calculating time: '
print t1 - t0
