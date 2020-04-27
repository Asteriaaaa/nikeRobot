import math
from scipy.integrate import dblquad
from functools import partial
from mpl_toolkits.mplot3d import Axes3D

import numpy as np
import matplotlib.pyplot as plt
import sys


#Referred to https://github.com/zh-plus

SAMPLES = 1000
MAX_DIS = 100

s_index = [30, 45, 65, 80]
rect = [(x, y) for x in np.linspace(s_index[0], s_index[1], 4) for y in np.linspace(s_index[2], s_index[3], 4)]
p1 = (45, 30)
p2 = (54, 42)
p_start = [50, 20]
p_end = [50, 80]


def normal(x, y, mean, sigma=1):
    m_x, m_y = mean
    return np.exp(-((x - m_x) ** 2 + (y - m_y) ** 2) / (2 * sigma ** 2)) / (2 * math.pi * sigma ** 2)


def hit(obstacle, sigma):   
    f = partial(normal, mean=obstacle, sigma=sigma)
    mu, error = dblquad(f, 0, MAX_DIS, 0, MAX_DIS)
    mu = 1/ mu

    return lambda x, y: mu * normal(x,y,obstacle, sigma)


def likelihood(f):
    x = np.linspace(0, MAX_DIS, SAMPLES)
    y = np.linspace(0, MAX_DIS, SAMPLES)
    X, Y = np.meshgrid(x, y)
    Y = Y[::-1]  
    Z = np.array(list(map(f, X, Y)))

    fig = plt.figure()
    plt.imshow(Z, extent=[0, MAX_DIS, 0, MAX_DIS])

    p_X, p_Y = zip(p1, p2)
    plt.scatter(p_X, p_Y, color='r')

    pc = plt.gca()
    rect = plt.Rectangle((s_index[0], s_index[2]), 20, 15, linewidth=2, edgecolor='r', facecolor='none')
    pc.add_patch(rect)

    plt.scatter(p_start[0],p_start[1], color='r')
    line = plt.plot((p_start[0], p_end[0]), (p_start[1],p_end[1]) , color='w', linestyle='--')

    plt.show()


def beam(f):
    line_samples = SAMPLES
    x = np.full(line_samples, 50)
    y = np.linspace(p_start[1], p_end[1], line_samples)
    Z = np.array(list(map(f, x, y)))

    fig = plt.figure()
    plt.plot(y, Z)

    plt.show()

    

if __name__ == "__main__":
    p1_hit = hit(p1, 4)
    p2_hit = hit(p2, 4)
    rect_hit_f = []
    for p in rect:
        rect_hit_f.append(hit(p,4))
    rect_hit = lambda x, y: sum([f(x, y) for f in rect_hit_f]) / len(rect_hit_f) * 5

    f = lambda x, y: np.array([0.3,0.3,0.4]).T @ [p1_hit(x, y), p2_hit(x, y), rect_hit(x, y)]

    likelihood(f)
    beam(f)
    
