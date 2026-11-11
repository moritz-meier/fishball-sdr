# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADDRESS_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ALMOST_EMPTY_THRESHOLD" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ALMOST_FULL_THRESHOLD" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ASYNC_CLK" -parent ${Page_0}
  ipgui::add_param $IPINST -name "M_AXIS_REGISTERED" -parent ${Page_0}
  ipgui::add_param $IPINST -name "M_DATA_WIDTH" -parent ${Page_0}
  set REDUCED_FIFO [ipgui::add_param $IPINST -name "REDUCED_FIFO" -parent ${Page_0}]
  set_property tooltip {Limit the amount of samples the FIFO can accumulate. Enabling this bit may reduce the size of Address, Almost Empty Threshold and Almost Full Threshold depending on the Slave and Master data width ratio.} ${REDUCED_FIFO}
  ipgui::add_param $IPINST -name "S_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TKEEP_EN" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TLAST_EN" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADDRESS_WIDTH { PARAM_VALUE.ADDRESS_WIDTH } {
	# Procedure called to update ADDRESS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDRESS_WIDTH { PARAM_VALUE.ADDRESS_WIDTH } {
	# Procedure called to validate ADDRESS_WIDTH
	return true
}

proc update_PARAM_VALUE.ALMOST_EMPTY_THRESHOLD { PARAM_VALUE.ALMOST_EMPTY_THRESHOLD } {
	# Procedure called to update ALMOST_EMPTY_THRESHOLD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ALMOST_EMPTY_THRESHOLD { PARAM_VALUE.ALMOST_EMPTY_THRESHOLD } {
	# Procedure called to validate ALMOST_EMPTY_THRESHOLD
	return true
}

proc update_PARAM_VALUE.ALMOST_FULL_THRESHOLD { PARAM_VALUE.ALMOST_FULL_THRESHOLD } {
	# Procedure called to update ALMOST_FULL_THRESHOLD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ALMOST_FULL_THRESHOLD { PARAM_VALUE.ALMOST_FULL_THRESHOLD } {
	# Procedure called to validate ALMOST_FULL_THRESHOLD
	return true
}

proc update_PARAM_VALUE.ASYNC_CLK { PARAM_VALUE.ASYNC_CLK } {
	# Procedure called to update ASYNC_CLK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ASYNC_CLK { PARAM_VALUE.ASYNC_CLK } {
	# Procedure called to validate ASYNC_CLK
	return true
}

proc update_PARAM_VALUE.M_AXIS_REGISTERED { PARAM_VALUE.M_AXIS_REGISTERED } {
	# Procedure called to update M_AXIS_REGISTERED when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_AXIS_REGISTERED { PARAM_VALUE.M_AXIS_REGISTERED } {
	# Procedure called to validate M_AXIS_REGISTERED
	return true
}

proc update_PARAM_VALUE.M_DATA_WIDTH { PARAM_VALUE.M_DATA_WIDTH } {
	# Procedure called to update M_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_DATA_WIDTH { PARAM_VALUE.M_DATA_WIDTH } {
	# Procedure called to validate M_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.REDUCED_FIFO { PARAM_VALUE.REDUCED_FIFO } {
	# Procedure called to update REDUCED_FIFO when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.REDUCED_FIFO { PARAM_VALUE.REDUCED_FIFO } {
	# Procedure called to validate REDUCED_FIFO
	return true
}

proc update_PARAM_VALUE.S_DATA_WIDTH { PARAM_VALUE.S_DATA_WIDTH } {
	# Procedure called to update S_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_DATA_WIDTH { PARAM_VALUE.S_DATA_WIDTH } {
	# Procedure called to validate S_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.TKEEP_EN { PARAM_VALUE.TKEEP_EN } {
	# Procedure called to update TKEEP_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TKEEP_EN { PARAM_VALUE.TKEEP_EN } {
	# Procedure called to validate TKEEP_EN
	return true
}

proc update_PARAM_VALUE.TLAST_EN { PARAM_VALUE.TLAST_EN } {
	# Procedure called to update TLAST_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TLAST_EN { PARAM_VALUE.TLAST_EN } {
	# Procedure called to validate TLAST_EN
	return true
}


proc update_MODELPARAM_VALUE.ASYNC_CLK { MODELPARAM_VALUE.ASYNC_CLK PARAM_VALUE.ASYNC_CLK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ASYNC_CLK}] ${MODELPARAM_VALUE.ASYNC_CLK}
}

proc update_MODELPARAM_VALUE.S_DATA_WIDTH { MODELPARAM_VALUE.S_DATA_WIDTH PARAM_VALUE.S_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.S_DATA_WIDTH}] ${MODELPARAM_VALUE.S_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.ADDRESS_WIDTH { MODELPARAM_VALUE.ADDRESS_WIDTH PARAM_VALUE.ADDRESS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDRESS_WIDTH}] ${MODELPARAM_VALUE.ADDRESS_WIDTH}
}

proc update_MODELPARAM_VALUE.M_DATA_WIDTH { MODELPARAM_VALUE.M_DATA_WIDTH PARAM_VALUE.M_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.M_DATA_WIDTH}] ${MODELPARAM_VALUE.M_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.M_AXIS_REGISTERED { MODELPARAM_VALUE.M_AXIS_REGISTERED PARAM_VALUE.M_AXIS_REGISTERED } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.M_AXIS_REGISTERED}] ${MODELPARAM_VALUE.M_AXIS_REGISTERED}
}

proc update_MODELPARAM_VALUE.ALMOST_EMPTY_THRESHOLD { MODELPARAM_VALUE.ALMOST_EMPTY_THRESHOLD PARAM_VALUE.ALMOST_EMPTY_THRESHOLD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ALMOST_EMPTY_THRESHOLD}] ${MODELPARAM_VALUE.ALMOST_EMPTY_THRESHOLD}
}

proc update_MODELPARAM_VALUE.ALMOST_FULL_THRESHOLD { MODELPARAM_VALUE.ALMOST_FULL_THRESHOLD PARAM_VALUE.ALMOST_FULL_THRESHOLD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ALMOST_FULL_THRESHOLD}] ${MODELPARAM_VALUE.ALMOST_FULL_THRESHOLD}
}

proc update_MODELPARAM_VALUE.TLAST_EN { MODELPARAM_VALUE.TLAST_EN PARAM_VALUE.TLAST_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TLAST_EN}] ${MODELPARAM_VALUE.TLAST_EN}
}

proc update_MODELPARAM_VALUE.TKEEP_EN { MODELPARAM_VALUE.TKEEP_EN PARAM_VALUE.TKEEP_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TKEEP_EN}] ${MODELPARAM_VALUE.TKEEP_EN}
}

proc update_MODELPARAM_VALUE.REDUCED_FIFO { MODELPARAM_VALUE.REDUCED_FIFO PARAM_VALUE.REDUCED_FIFO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.REDUCED_FIFO}] ${MODELPARAM_VALUE.REDUCED_FIFO}
}

