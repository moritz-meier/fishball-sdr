# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "DIV_RATE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ID" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NUM_OF_CLOCKS" -parent ${Page_0}
  #Adding Group
  set FPGA_info [ipgui::add_group $IPINST -name "FPGA info" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "FPGA_TECHNOLOGY" -parent ${FPGA_info} -widget comboBox



}

proc update_PARAM_VALUE.DIV_RATE { PARAM_VALUE.DIV_RATE } {
	# Procedure called to update DIV_RATE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DIV_RATE { PARAM_VALUE.DIV_RATE } {
	# Procedure called to validate DIV_RATE
	return true
}

proc update_PARAM_VALUE.FPGA_TECHNOLOGY { PARAM_VALUE.FPGA_TECHNOLOGY } {
	# Procedure called to update FPGA_TECHNOLOGY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FPGA_TECHNOLOGY { PARAM_VALUE.FPGA_TECHNOLOGY } {
	# Procedure called to validate FPGA_TECHNOLOGY
	return true
}

proc update_PARAM_VALUE.ID { PARAM_VALUE.ID } {
	# Procedure called to update ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ID { PARAM_VALUE.ID } {
	# Procedure called to validate ID
	return true
}

proc update_PARAM_VALUE.NUM_OF_CLOCKS { PARAM_VALUE.NUM_OF_CLOCKS } {
	# Procedure called to update NUM_OF_CLOCKS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_OF_CLOCKS { PARAM_VALUE.NUM_OF_CLOCKS } {
	# Procedure called to validate NUM_OF_CLOCKS
	return true
}


proc update_MODELPARAM_VALUE.FPGA_TECHNOLOGY { MODELPARAM_VALUE.FPGA_TECHNOLOGY PARAM_VALUE.FPGA_TECHNOLOGY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FPGA_TECHNOLOGY}] ${MODELPARAM_VALUE.FPGA_TECHNOLOGY}
}

proc update_MODELPARAM_VALUE.ID { MODELPARAM_VALUE.ID PARAM_VALUE.ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ID}] ${MODELPARAM_VALUE.ID}
}

proc update_MODELPARAM_VALUE.NUM_OF_CLOCKS { MODELPARAM_VALUE.NUM_OF_CLOCKS PARAM_VALUE.NUM_OF_CLOCKS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_OF_CLOCKS}] ${MODELPARAM_VALUE.NUM_OF_CLOCKS}
}

proc update_MODELPARAM_VALUE.DIV_RATE { MODELPARAM_VALUE.DIV_RATE PARAM_VALUE.DIV_RATE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DIV_RATE}] ${MODELPARAM_VALUE.DIV_RATE}
}

