# CFD

[Python prototype](https://colab.research.google.com/drive/169wsArsvZh4bEdJta2ckro3zzxF1lknP?usp=sharing)

## Run simulation
CFD module only (use `plot.py` to preview the output values of the CFD - no zero-crossing detection yet).
```
iverilog -o cfd_sim.vvp cfd.v cfd_tb.v
vvp cfd_sim.vvp
```
