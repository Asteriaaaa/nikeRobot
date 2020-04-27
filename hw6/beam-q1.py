import math
import matplotlib.pyplot as plt
from scipy import integrate
import numpy as np

sigma_hit=10; 
lambda_short=0.05
z_hit= 0.5
z_short=0.4
z_MAX = 500
z_max=0.01
z_rand=0.09
K = 10000
t=0


def p_hit(z_tk,z_tk_star, sigma_hit, z_MAX):
    if z_tk < 0 or z_tk > z_MAX:
        return 0
    N = lambda x: 1/math.sqrt(2*math.pi*sigma_hit**2) * \
        np.exp(-((x-z_MAX/2)**2/(2*sigma_hit**2)))
   
    ita = pow(integrate.quad(N,0,z_MAX)[0] ,-1)
    result = ita*N(z_tk)
    #print(result)
    return result

def p_short(z_tk,z_tk_star,lambda_short):
    if z_tk < 0 or z_tk > z_tk_star or t > K / 2:
        return 0
    ita = 1 /(1-pow(math.e, -lambda_short*z_MAX/2))
    result = ita * lambda_short * pow(math.e, (-lambda_short*z_tk_star))
    return result
    
def p_max(z_tk, z_MAX):
    #print(z_tk)
    return 1 if z_tk == z_MAX else 0

def p_rand(z_tk, z_MAX):
    if z_tk < 0 or z_tk > z_MAX:
        return 0
    return 1/z_MAX


def beam_range_finder_model(distance_star=np.linspace(0, z_MAX, 10000), K=10000):
    distance_star = np.linspace(0, z_MAX, 10000)
    distance = distance_star 
    global t
    q = [1]*10001
    a=[]
    b = []
    c = []
    d = []
    for k in range(1,K+1):
        a.append(z_hit * p_hit(distance[k-1],distance_star[k-1],sigma_hit, z_MAX))
        b.append(z_short * p_short(distance[k-1],distance_star[k-1],lambda_short))
        c.append( z_max * p_max(distance[k-1],z_MAX))
        d.append(z_rand * p_rand(distance[k-1], z_MAX))
        q[k] = a[k-1]+b[k-1]+c[k-1]+d[k-1]
        t += 1
        #print(p)
    plt.plot(distance, q[1:])
    plt.show()
    return q

if __name__ == '__main__':
    q = beam_range_finder_model()
    #print(q)