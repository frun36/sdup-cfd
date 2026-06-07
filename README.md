# CFD

[Python prototype](https://colab.research.google.com/drive/169wsArsvZh4bEdJta2ckro3zzxF1lknP?usp=sharing)

## Run simulation
CFD module only (use `plot.py` to preview the output values of the CFD, with noise-immune zero-crossing detector).
```
verilator --binary --timing --timescale 1ns/1ps -Wno-fatal cfd_tb.sv top.sv zero_crossing_detector.sv tdc.sv
obj_dir/Vcfd_tb +verilator+seed+42
```
