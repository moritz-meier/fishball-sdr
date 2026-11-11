# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "DST_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LENGTH_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RD_DATA_REGISTERED" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RD_FIFO_ADDRESS_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SRC_DATA_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.DST_DATA_WIDTH { PARAM_VALUE.DST_DATA_WIDTH } {
	# Procedure called to update DST_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DST_DATA_WIDTH { PARAM_VALUE.DST_DATA_WIDTH } {
	# Procedure called to validate DST_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.LENGTH_WIDTH { PARAM_VALUE.LENGTH_WIDTH } {
	# Procedure called to update LENGTH_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LENGTH_WIDTH { PARAM_VALUE.LENGTH_WIDTH } {
	# Procedure called to validate LENGTH_WIDTH
	return true
}

proc update_PARAM_VALUE.RD_DATA_REGISTERED { PARAM_VALUE.RD_DATA_REGISTERED } {
	# Procedure called to update RD_DATA_REGISTERED when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RD_DATA_REGISTERED { PARAM_VALUE.RD_DATA_REGISTERED } {
	# Procedure called to validate RD_DATA_REGISTERED
	return true
}

proc update_PARAM_VALUE.RD_FIFO_ADDRESS_WIDTH { PARAM_VALUE.RD_FIFO_ADDRESS_WIDTH } {
	# Procedure called to update RD_FIFO_ADDRESS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RD_FIFO_ADDRESS_WIDTH { PARAM_VALUE.RD_FIFO_ADDRESS_WIDTH } {
	# Procedure called to validate RD_FIFO_ADDRESS_WIDTH
	return true
}

proc update_PARAM_VALUE.SRC_DATA_WIDTH { PARAM_VALUE.SRC_DATA_WIDTH } {
	# Procedure called to update SRC_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SRC_DATA_WIDTH { PARAM_VALUE.SRC_DATA_WIDTH } {
	# Procedure called to validate SRC_DATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.SRC_DATA_WIDTH { MODELPARAM_VALUE.SRC_DATA_WIDTH PARAM_VALUE.SRC_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SRC_DATA_WIDTH}] ${MODELPARAM_VALUE.SRC_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.DST_DATA_WIDTH { MODELPARAM_VALUE.DST_DATA_WIDTH PARAM_VALUE.DST_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DST_DATA_WIDTH}] ${MODELPARAM_VALUE.DST_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.LENGTH_WIDTH { MODELPARAM_VALUE.LENGTH_WIDTH PARAM_VALUE.LENGTH_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LENGTH_WIDTH}] ${MODELPARAM_VALUE.LENGTH_WIDTH}
}

proc update_MODELPARAM_VALUE.RD_DATA_REGISTERED { MODELPARAM_VALUE.RD_DATA_REGISTERED PARAM_VALUE.RD_DATA_REGISTERED } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RD_DATA_REGISTERED}] ${MODELPARAM_VALUE.RD_DATA_REGISTERED}
}

proc update_MODELPARAM_VALUE.RD_FIFO_ADDRESS_WIDTH { MODELPARAM_VALUE.RD_FIFO_ADDRESS_WIDTH PARAM_VALUE.RD_FIFO_ADDRESS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RD_FIFO_ADDRESS_WIDTH}] ${MODELPARAM_VALUE.RD_FIFO_ADDRESS_WIDTH}
}

