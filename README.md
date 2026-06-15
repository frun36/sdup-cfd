# CFD

[Python prototype](https://colab.research.google.com/drive/169wsArsvZh4bEdJta2ckro3zzxF1lknP?usp=sharing) used for tuning CFD parameters and generating input pulses. File is also availabe inside the analysis folder for local use.

## Run simulation
CFD module only, using `verilator` for synthesis. Use `plot.py` inside analysis folder to preview the output values of the CFD, with noise-immune zero-crossing detector.
``` bash
./verilate.sh
```

## Vivado
Use TCL scripts to reconstruct the projects.
```powershell
write_bd_tcl -force [get_property directory [current_project]]/rebuild_bd.tcl
write_project_tcl -paths_relative_to [get_property directory [current_project]] -force [get_property directory [current_project]]/rebuild_project.tcl
```
