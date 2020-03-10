from scipy.optimize import differential_evolution
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

#name=float(input("name: "))
name='./datos/gpB/005'
data = pd.read_csv(str(name)+".dat", sep="\t", header=None)

N=len(data)
t=np.linspace(0.5,0.5*N,N)
temp=data[1]
temp2=data[2]

def sinfit(x):
    y=x[0]*np.sin(2*np.pi*x[1]*t+x[2])+x[3]
    return y

def fun(x):
    ms=sinfit(x)
    return sum(abs((ms-temp)**2))

def fun2(x):
    ms=sinfit(x)
    return sum(abs((ms-temp2)**2))

bounds = [(0, 10), (0.01, 0.03),(round(np.pi,5),3*round(np.pi,5)),(25,40)]

result1 = differential_evolution(fun, bounds,polish=True)
result2 = differential_evolution(fun2, bounds,polish=True)

x1=[]
for i in result1.x:
    x1.append(round(i,4))
print(x1)

x2=[]
for i in result2.x:
    x2.append(round(i,4))
print(x2)


datgen=sinfit(x1)
datgen2=sinfit(x2)


diffx1=round(np.pi,5)*x1[1]*(4.5e-3/(abs(x1[2]-x2[2])))**2
diffx2=np.pi*x1[1]*(4.5e-3/(abs(x1[2]-x2[2]-2*np.pi)))**2


#print(diff)
#print(diff2)
print(round(diffx1,14))
print(round(diffx2,14))

plt.figure(figsize=(20,8),dpi=50)
plt.scatter(t,temp,marker='.');
plt.plot(t,datgen,color='red')
plt.xlim([0,300])
plt.savefig(str(name)+'peltier')
plt.show()
plt.close('all')

plt.figure(figsize=(20,8),dpi=50)
plt.scatter(t,temp2,marker='.');
plt.plot(t,datgen2,color='red')
plt.xlim([0,500])
plt.savefig(str(name)+'muestra')
plt.show()
plt.close('all')