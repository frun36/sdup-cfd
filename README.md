# CFD

[Python prototype](https://colab.research.google.com/drive/169wsArsvZh4bEdJta2ckro3zzxF1lknP?usp=sharing)

## Run simulation
CFD module only (use `plot.py` to preview the output values of the CFD, with noise-immune zero-crossing detector).
```
iverilog -o cfd_sim.vvp cfd.v cfd_tb.v top.v zero_crossing_detector.v
vvp cfd_sim.vvp
```
