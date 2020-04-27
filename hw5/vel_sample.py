import matplotlib.pyplot as plt
import numpy as np
from sample import sample_normal
import math

def gen_sample(a1,a2,a3,a4,a5,a6):
#start from (2,2,pi/6)
    v=5
    w=math.pi/30
    r=v/w
    deltat = 1
    theta = math.pi/6
    plt.plot(2,2,'om')
    plt.quiver(2,2, 3,3*math.tan(theta))

    v_hat=[]
    w_hat=[]
    gamma_hat=[]
    for i in range(500):
        v_hat.append(v+sample_normal(a1*abs(v)+a2*abs(w)))
        w_hat.append(w+sample_normal(a3*abs(v)+a4*abs(w)))
        gamma_hat.append(sample_normal(a5*abs(v)+a6*abs(w)))
    v_hat=np.array(v_hat)
    w_hat=np.array(w_hat)
    gamma_hat=np.array(gamma_hat)
    x_prime = 2-(v_hat/w_hat)*np.sin(theta)+(v_hat/w_hat)*np.sin(theta+w_hat*deltat)
    y_prime = 2+(v_hat/w_hat)*np.cos(theta)-(v_hat/w_hat)*np.cos(theta+w_hat*deltat)
    theta_prime = theta+w_hat*deltat+gamma_hat*deltat

    x_avg=np.average(x_prime)
    y_avg=np.average(y_prime)
    theta_avg=np.average(theta_prime)

    plt.plot(x_avg,y_avg,'om')
    plt.quiver(x_avg,y_avg, x_avg+1,(x_avg+1)*math.tan(theta_avg))
    plt.xlim(0,10)
    plt.ylim(0,10)
    plt.scatter(x_prime, y_prime)
    plt.show()

if __name__ == '__main__':
    gen_sample(0.01,0.01,0.5,0.5,5,5) # case 3
    gen_sample(0.5,0.5,0.01,0.01,5,5) # case 2
    gen_sample(0.1,0.1,0.2,0.2,0.1,0.1) # case 1
