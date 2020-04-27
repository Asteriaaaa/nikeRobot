import matplotlib.pyplot as plt
import numpy as np
from sample import sample_normal
import math

def gen_sample(a1,a2,a3,a4):
#start from (0,0,0)
    x=2
    y=2
    theta=math.pi/4

    trans=math.sqrt((x-0)**2 + (y-0)**2)
    rot1=math.atan2(2-0, 2-0) - theta
    rot2=theta-0-rot1

    plt.plot(0,0,'om')
    plt.quiver(0,0,1,0)
    rot1_hat = []
    trans_hat = []
    rot2_hat = []
    for i in range(500):
        rot1_hat.append(rot1 + sample_normal(a1*abs(rot1)+a2*trans))
        trans_hat.append(trans + \
            sample_normal(a3*trans + a4*(abs(rot1)+abs(rot2))))
        rot2_hat.append(rot2+sample_normal(a1*abs(rot2)+a2*trans))
    rot1_hat = np.array(rot1_hat)
    rot2_hat = np.array(rot2_hat)
    trans_hat = np.array(trans_hat)

    x_prime = x + trans_hat*np.cos(theta+rot1_hat)
    y_prime = y + trans_hat*np.sin(theta+rot1_hat)
    theta_prime = theta + rot1_hat + rot2_hat

    x_avg=np.average(x_prime)
    y_avg=np.average(y_prime)

    plt.plot(x_avg,y_avg,'om')
    plt.quiver(x_avg,y_avg, x_avg+1,(x_avg+1)*y_avg/x_avg)
    plt.xlim(0,10)
    plt.ylim(0,10)
    plt.scatter(x_prime, y_prime)
    plt.show()


if __name__ == '__main__':
    a1=0.5
    a2=0.5   #case 3
    a3=0.01
    a4=0.01
    gen_sample(a1,a2,a3,a4)
    a1=0.01
    a2=0.01
    a3=0.5  #case 2
    a4=0.5
    gen_sample(a1,a2,a3,a4)
    a1 = 0.5
    a2 = 0.5
    a3 = 0.7 # case 1
    a4 = 0.7
    gen_sample(a1,a2,a3,a4)