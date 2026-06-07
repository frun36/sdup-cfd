import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

ADC_PERIOD_NS = 0.5
DATA_MUX = 16
CLK_PERIOD_NS = ADC_PERIOD_NS * DATA_MUX  # (4ns = 125 MHz)

df = pd.read_csv("output.csv", sep=",")

t = df["time_ns"]
din = df["din"]
dout = df["dout"]  # delayed by 1 clk cycle

# # Old pulse logic
# pulse = df["pulse"]  # delayed by 2 clk cycles
# for timestamp, is_pulse in zip(t, pulse):
#     if is_pulse == 1:
#         plt.axvline(x=timestamp - 2 * CLK_PERIOD_NS, color="green")

# New pulse logic
hits = []
with open("hits.csv", "r") as f:
    for line in f:
        line_stripped = line.strip()
        if line_stripped != "":
            hits.append(int(line_stripped))

for timestamp in hits:
    timestamp_ns = (timestamp * ADC_PERIOD_NS)
    plt.axvline(x=timestamp_ns, color="green")


plt.plot(t, din, label="p", color="blue")
plt.plot(t - CLK_PERIOD_NS, dout, label="sum", color="purple", linestyle="--")
x_max = int(np.max(t))

plt.xlabel("t")
plt.ylabel("V")
plt.legend()
plt.grid(True)

plt.show()
