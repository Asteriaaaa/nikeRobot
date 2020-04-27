import math
import matplotlib.pyplot as plt
from scipy import integrate
from scipy.stats import rv_continuous

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
a=[]
b = []
c = []
d = []
q = [1]*10001


class Dummy(rv_continuous):
    def _pdf (self, x1, x2, x3, x4):
        return 0.5 * x1 + 0.4 * x2 + 0.01 * x3 + 0.09 *x4

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

    for k in range(1,K+1):
        a.append( p_hit(distance[k-1],distance_star[k-1],sigma_hit, z_MAX))
        b.append( p_short(distance[k-1],distance_star[k-1],lambda_short))
        c.append(  p_max(distance[k-1],z_MAX))
        d.append( p_rand(distance[k-1], z_MAX))
        q[k] = z_hit *a[k-1]+z_short *b[k-1]+z_max *c[k-1]+z_rand *d[k-1]
        t += 1
    
    dm= Dummy(name='dummy')
    p1,p2,p3,p4,err = dm.fit(data = q[1:])
    nor = 1/(p1+p2+p3+p4)
    p1 *= nor
    p2 *= nor
    p3 *= nor
    p4 *= nor
    print(p1,p2,p3,p4)

    for k in range(1,K+1):
        q[k] = p1*a[k-1]+p2 *b[k-1]+p3 *c[k-1]+p4 *d[k-1]
    plt.plot(distance, q[1:])
    plt.show()




if __name__ == '__main__':
    q = beam_range_finder_model()
