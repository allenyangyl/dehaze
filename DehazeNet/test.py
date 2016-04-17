import numpy as np

# Make sure that caffe is on the python path:
caffe_root = '../../caffe/'  # this file is expected to be in {caffe_root}/examples
import sys
sys.path.insert(0, caffe_root + 'python')

import caffe

test_listfile = 'TestLabels.txt'

caffe.set_device(4)
caffe.set_mode_gpu()
net = caffe.Net('test.prototxt',
                'models/model_iter_300000.caffemodel',
                caffe.TEST)

test_list = np.loadtxt(test_listfile,  str, comments=None, delimiter='\n')
data_counts = len(test_list)
batch_size = net.blobs['data'].data.shape[0]
batch_count = int(np.ceil(data_counts * 1.0 / batch_size))
loss = 0

print(batch_count)
for i in range(batch_count):

	out = net.forward()
		
	loss_this = net.blobs['loss'].data
	loss = loss + loss_this
	print str(i) + ' ' +  str(loss_this)

loss = loss / batch_count

print loss

