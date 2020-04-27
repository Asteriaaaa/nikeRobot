import random, time
random.seed(time.time())

def sample_normal(b):
    value = 0
    for i in range(12):
        value += random.uniform(-b, b)
    value /= 12
    return value