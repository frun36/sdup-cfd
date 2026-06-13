verilator --binary --timing --timescale 1ns/1ps -Wno-fatal -Icfd/src/hdl cfd/src/tb/cfd_tb.sv cfd/src/hdl/cfd_top.sv cfd/src/hdl/cfd.sv cfd/src/hdl/zero_crossing_detector.sv cfd/src/hdl/tdc.sv
ln -sf cfd/src/tb/input.csv ./input.csv
./obj_dir/Vcfd_tb
mv output.csv analysis/output.csv
rm input.csv
