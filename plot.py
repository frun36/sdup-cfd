import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

df = pd.read_csv('output.csv', sep=',')

t = df['time_ns']
din = df['din']
dout = df['dout']
pulse = df['pulse']


for x, p in zip(t, pulse):
    if p == 1:
        plt.axvline(x=x, color='green')
x_max = int(np.max(t))

plt.plot(t, din, label='p', color='blue')
plt.plot(t, dout, label='sum', color='purple', linestyle='--')

plt.xlabel('t')
plt.ylabel('V')
plt.legend()
plt.grid(True)

plt.show()
