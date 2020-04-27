import matplotlib.pyplot as plt
import numpy as np
from sample import sample_normal
import math

barrier_x = (3,6)
barrier_y = (4,5)

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
    i=0
    for i in range(10000):
        rot1_s = rot1 + sample_normal(a1*abs(rot1)+a2*trans)
        trans_s = trans + \
            sample_normal(a3*trans + a4*(abs(rot1)+abs(rot2)))
        rot2_s = rot2+sample_normal(a1*abs(rot2)+a2*trans)
        rot1_hat.append(rot1_s)
        trans_hat.append(trans_s)
        rot2_hat.append(rot2_s)

    rot1_hat = np.array(rot1_hat)
    rot2_hat = np.array(rot2_hat)
    trans_hat = np.array(trans_hat)

    x_prime = x + trans_hat*np.cos(theta+rot1_hat)
    y_prime = y + trans_hat*np.sin(theta+rot1_hat)
    theta_prime = theta + rot1_hat + rot2_hat

    j=0
    i=0
    x_real=[]
    y_real=[]
    theta_real=[]
    while j < 500:
        if x_prime[i]+0.001 > barrier_x[0] and x_prime[i]-0.001 < barrier_x[1] \
        and y_prime[i]+0.001 > barrier_y[0] and y_prime[i]-0.001 < barrier_y[1]:
            pass
        else:
            x_real.append(x_prime[i])
            y_real.append(y_prime[i])
            theta_real.append(theta_prime[i])
            j += 1
        i+=1
        if i>=len(x_prime):
            break

            
    x_avg=np.average(x_real)
    y_avg=np.average(y_real)

    plt.plot([3,3],[4,5])
    plt.plot([6,6],[4,5])
    plt.plot([3,6],[5,5])
    plt.plot([3,6],[4,4])

    plt.plot(x_avg,y_avg,'om')
    plt.quiver(x_avg,y_avg, x_avg+1,(x_avg+1)*y_avg/x_avg)
    plt.xlim(0,10)
    plt.ylim(0,10)
    plt.scatter(x_real, y_real,s=2)
    plt.show()


if __name__ == '__main__':
    a1=0.5
    a2=0.5   #case 3
    a3=0.01
    a4=0.01
    #gen_sample(a1,a2,a3,a4)
    gen_sample(0.5,0.5,0.5,0.5)