# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "BIT_WIDTH_IN" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BIT_WIDTH_OUT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DATA_MUX" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DELAY" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FPGA_TIME_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "M_AXIS_TDATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SCALE_DIV" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SCALE_MULT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "S_AXIS_TDATA_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.BIT_WIDTH_IN { PARAM_VALUE.BIT_WIDTH_IN } {
	# Procedure called to update BIT_WIDTH_IN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BIT_WIDTH_IN { PARAM_VALUE.BIT_WIDTH_IN } {
	# Procedure called to validate BIT_WIDTH_IN
	return true
}

proc update_PARAM_VALUE.BIT_WIDTH_OUT { PARAM_VALUE.BIT_WIDTH_OUT } {
	# Procedure called to update BIT_WIDTH_OUT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BIT_WIDTH_OUT { PARAM_VALUE.BIT_WIDTH_OUT } {
	# Procedure called to validate BIT_WIDTH_OUT
	return true
}

proc update_PARAM_VALUE.DATA_MUX { PARAM_VALUE.DATA_MUX } {
	# Procedure called to update DATA_MUX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_MUX { PARAM_VALUE.DATA_MUX } {
	# Procedure called to validate DATA_MUX
	return true
}

proc update_PARAM_VALUE.DELAY { PARAM_VALUE.DELAY } {
	# Procedure called to update DELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY { PARAM_VALUE.DELAY } {
	# Procedure called to validate DELAY
	return true
}

proc update_PARAM_VALUE.FPGA_TIME_WIDTH { PARAM_VALUE.FPGA_TIME_WIDTH } {
	# Procedure called to update FPGA_TIME_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FPGA_TIME_WIDTH { PARAM_VALUE.FPGA_TIME_WIDTH } {
	# Procedure called to validate FPGA_TIME_WIDTH
	return true
}

proc update_PARAM_VALUE.M_AXIS_TDATA_WIDTH { PARAM_VALUE.M_AXIS_TDATA_WIDTH } {
	# Procedure called to update M_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_AXIS_TDATA_WIDTH { PARAM_VALUE.M_AXIS_TDATA_WIDTH } {
	# Procedure called to validate M_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.SCALE_DIV { PARAM_VALUE.SCALE_DIV } {
	# Procedure called to update SCALE_DIV when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SCALE_DIV { PARAM_VALUE.SCALE_DIV } {
	# Procedure called to validate SCALE_DIV
	return true
}

proc update_PARAM_VALUE.SCALE_MULT { PARAM_VALUE.SCALE_MULT } {
	# Procedure called to update SCALE_MULT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SCALE_MULT { PARAM_VALUE.SCALE_MULT } {
	# Procedure called to validate SCALE_MULT
	return true
}

proc update_PARAM_VALUE.S_AXIS_TDATA_WIDTH { PARAM_VALUE.S_AXIS_TDATA_WIDTH } {
	# Procedure called to update S_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_AXIS_TDATA_WIDTH { PARAM_VALUE.S_AXIS_TDATA_WIDTH } {
	# Procedure called to validate S_AXIS_TDATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.BIT_WIDTH_IN { MODELPARAM_VALUE.BIT_WIDTH_IN PARAM_VALUE.BIT_WIDTH_IN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BIT_WIDTH_IN}] ${MODELPARAM_VALUE.BIT_WIDTH_IN}
}

proc update_MODELPARAM_VALUE.DATA_MUX { MODELPARAM_VALUE.DATA_MUX PARAM_VALUE.DATA_MUX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_MUX}] ${MODELPARAM_VALUE.DATA_MUX}
}

proc update_MODELPARAM_VALUE.DELAY { MODELPARAM_VALUE.DELAY PARAM_VALUE.DELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY}] ${MODELPARAM_VALUE.DELAY}
}

proc update_MODELPARAM_VALUE.SCALE_DIV { MODELPARAM_VALUE.SCALE_DIV PARAM_VALUE.SCALE_DIV } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SCALE_DIV}] ${MODELPARAM_VALUE.SCALE_DIV}
}

proc update_MODELPARAM_VALUE.SCALE_MULT { MODELPARAM_VALUE.SCALE_MULT PARAM_VALUE.SCALE_MULT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SCALE_MULT}] ${MODELPARAM_VALUE.SCALE_MULT}
}

proc update_MODELPARAM_VALUE.BIT_WIDTH_OUT { MODELPARAM_VALUE.BIT_WIDTH_OUT PARAM_VALUE.BIT_WIDTH_OUT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BIT_WIDTH_OUT}] ${MODELPARAM_VALUE.BIT_WIDTH_OUT}
}

proc update_MODELPARAM_VALUE.FPGA_TIME_WIDTH { MODELPARAM_VALUE.FPGA_TIME_WIDTH PARAM_VALUE.FPGA_TIME_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FPGA_TIME_WIDTH}] ${MODELPARAM_VALUE.FPGA_TIME_WIDTH}
}

proc update_MODELPARAM_VALUE.S_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.S_AXIS_TDATA_WIDTH PARAM_VALUE.S_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.S_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.S_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.M_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.M_AXIS_TDATA_WIDTH PARAM_VALUE.M_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.M_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.M_AXIS_TDATA_WIDTH}
}

