import math
import matplotlib.pyplot as plt
import numpy as np
import time

LandmarkX = np.array([0,4,4])
LandmarkY = np.array([0,0,8])

PointX =np.array( [6])
PointY = np.array( [4])
N = 500
sigma = 0.1
noise = 0.5
np.random.seed(int(time.time()))

dis = np.sqrt(np.power(PointX-LandmarkX,2)+np.power(PointY-LandmarkY,2))

noise = lambda x : np.random.randn()
samples_x = []
samples_y = []

def sample():
    i = 0
    while i < N:
        x = 0.2*np.random.randn() + 6
        y = 0.2*np.random.randn() + 4
        dis1 = dis - noise(1)
        dis2 = dis + noise(1)
        distance = np.sqrt(np.power([x]-LandmarkX,2)+np.power([y]-LandmarkY,2))
        rejected = False
        for index,item in enumerate(distance):
            if item > dis2[index] or item < dis1[index]:
                rejected = True
                break
        if not rejected:
            i += 1
            samples_x.append(x)
            samples_y.append(y)

if __name__ == '__main__':
    sample() 
    plt.scatter(samples_x,samples_y,s=5)
    plt.scatter(PointX,PointY, s=100,marker='d')
    plt.scatter(LandmarkX, LandmarkY, marker='*')
    plt.show()


