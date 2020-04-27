import matplotlib.pyplot as plt
import numpy as np
import random, time
import math

random.seed(time.time())

b=10
samples=[]
for i in range(1000000):
    value = 0
    for j in range(12):
        value += random.uniform(-10,10)
    value /= 12
    samples.append(value)

bins=np.arange(-15,15,0.01)
plt.hist(samples, bins, color='red')
plt.xlim(-15,15)
plt.show()

samples = []
bins=np.arange(-30,30,0.01)
for i in range(1000000):
    value = 0
    for j in range(2):
        value += random.uniform(-10,10)
    value *= math.sqrt(6)/2
    samples.append(value)
plt.hist(samples, bins, color='red')
plt.xlim(-30,30)
plt.show()

samples = []
bins=np.arange(-15,15,0.01)
for i in range (1000000):
    while True:
        x = random.uniform(-10,10)
        y = random.uniform(0, 10)
        if y <= abs(x):
            samples.append(x)
            break
plt.hist(samples, bins, color='red')
plt.xlim(-15,15)
plt.show()