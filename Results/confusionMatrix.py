'''
import matplotlib.pyplot as plt
import numpy as np
# Assume m is 2D Numpy array with these values
# [[1.0 0   0   0  ]
#  [0.1 0.7 0.2 0  ]
#  [0   0   1.0 0  ]
#  [0   0   0   1.0]]
'''
'''
m =np.array([[1102,0,0,0,0,0,0,0,0,0,0],
 [0,1308,0,0,0,0,0,0,0,0,0],
 [0,0,1792,0,0,0,0,0,0,0,0],
 [0,186,0,1343,0,0,0,0,0,0,0],
 [0,0,0,0,1509,356,0,0,0,0,0],
 [0,0,0,0,0,1580,0,0,0,0,0],
 [0,0,0,0,0,0,1812,0,0,0,0],
 [0,0,0,0,0,0,0,1853,0,0,0],
 [0,0,0,0,0,0,0,0,1856,54,0],
 [0,0,0,0,0,0,0,0,0,1835,0],
 [0,0,0,0,0,0,0,0,0,0,1662]],np.int32)
'''
'''
m =np.array([[1,0,0,0,0,0,0,0,0,0,0],
 [0,1,0,0,0,0,0,0,0,0,0],
 [0,0,1,0,0,0,0,0,0,0,0],
 [0,0.121648,0,0.87835,0,0,0,0,0,0,0],
 [0,0,0,0,0.80911,0.19088,0,0,0,0,0],
 [0,0,0,0,0,1,0,0,0,0,0],
 [0,0,0,0,0,0,1,0,0,0,0],
 [0,0,0,0,0,0,0,1,0,0,0],
 [0,0,0,0,0,0,0,0,0.9717,0.02827,0],
 [0,0,0,0,0,0,0,0,0,1,0],
 [0,0,0,0,0,0,0,0,0,0,1]],np.float)


plt.matshow(m)
plt.colorbar()
my_xticks = ['still','phone','write','drink','rinse','brush','tcouch','rcouch','chop','stir','comp']
plt.xticks([0,1,2,3,4,5,6,7,8,9,10],my_xticks)
plt.yticks([0,1,2,3,4,5,6,7,8,9,10],my_xticks)
plt.show()
'''

import numpy as np
import matplotlib.pyplot as plt

conf_arr = np.array([[1,0,0,0,0,0,0,0,0,0,0],
             [0,1,0,0,0,0,0,0,0,0,0],
             [0,0,1,0,0,0,0,0,0,0,0],
             [0,0.12,0,0.87,0,0,0,0,0,0,0],
             [0,0,0,0,0.81,0.19,0,0,0,0,0],
             [0,0,0,0,0,1,0,0,0,0,0],
             [0,0,0,0,0,0,1,0,0,0,0],
             [0,0,0,0,0,0,0,1,0,0,0],
             [0,0,0,0,0,0,0,0,0.97,0.02,0],
             [0,0,0,0,0,0,0,0,0,1,0],
             [0,0,0,0,0,0,0,0,0,0,1]])


norm_conf = []
for i in conf_arr:
    a = 0
    tmp_arr = []
    a = sum(i, 0)
    for j in i:
        tmp_arr.append(float(j)/float(a))
    norm_conf.append(tmp_arr)

fig = plt.figure()
plt.clf()
ax = fig.add_subplot(111)
ax.set_aspect(1)
res = ax.imshow(np.array(norm_conf), cmap=plt.cm.jet, 
                interpolation='nearest')

width, height = conf_arr.shape

for x in xrange(width):
    for y in xrange(height):
        ax.annotate(str(conf_arr[x][y]), xy=(y, x), 
                    horizontalalignment='center',
                    verticalalignment='center')

cb = fig.colorbar(res)
#alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
#plt.xticks(range(width), alphabet[:width])
#plt.yticks(range(height), alphabet[:height])
plt.title('Confusion Matrix for model train on person 1 and person 2, test on person 4',size=20)
my_xticks = ['still','phone','write','drink','rinse','brush','tcouch','rcouch','chop','stir','comp']
plt.xticks([0,1,2,3,4,5,6,7,8,9,10],my_xticks)
plt.yticks([0,1,2,3,4,5,6,7,8,9,10],my_xticks)

plt.savefig('confusion_matrix.png', format='png')
plt.show()
