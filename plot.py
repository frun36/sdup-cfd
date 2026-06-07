import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

ADC_PERIOD_NS = 0.5
DATA_MUX = 16
CLK_PERIOD_NS = ADC_PERIOD_NS * DATA_MUX  # (4ns = 125 MHz)

df = pd.read_csv("output.csv", sep=",")

t = df.loc[df["zcd_out_valid"] == 1, "timestamp"] * ADC_PERIOD_NS
din = df.loc[df["din_valid"] == 1, "din"]  # Timestamp based on din, stops when invalid
dout = df.loc[
    df["dout_valid"] == 1, "dout"
]  # Also trims the initial delay of 2*CLK_PERIOD_NS

for pulse, timestamp in zip(df["pulse"], df["out_timestamp"]):
    if pulse == 1:
        # the timestamp counter is started on ZCD output valid
        # no post-processing correction is required
        # only its arrival is delayed (3 FPGA clock cycles)
        timestamp_ns = (timestamp * ADC_PERIOD_NS)
        plt.axvline(x=timestamp_ns, color="green")

plt.plot(t, din[:len(t)], label="p", color="blue")
plt.plot(t, dout[:len(t)], label="sum", color="purple", linestyle="--")
x_max = int(np.max(t))

plt.xlabel("t")
plt.ylabel("V")
plt.legend()
plt.grid(True)

plt.show()
