import swigex as sw
import numpy as np

def cova(scale):
    def eval(h):
        return np.exp(-h/scale)
    return eval

scale1 = 2.
scale2 = 0.1
scale3 = 0.5

u1 = cova(scale1)
u2 = cova(scale2)
u3 = cova(scale3)

us1 =  sw.CovAniso(scale1)
us2 =  sw.CovAniso(scale2)
us3 =  sw.CovAniso(scale3)

h = 2.4
print(u1(h)-us1.evalCov(h))
print(u2(h)-us2.evalCov(h))


usum = sw.ACov.sum(us1,us2)
print(usum.evalCov(h) - (u1(h)+u2(h)))

uproduct = sw.ACov.product(usum,us3)
print(uproduct.evalCov(h) - u3(h) * (u1(h)+u2(h)))

