# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set I3C_Controller_Core [ipgui::add_page $IPINST -name "I3C Controller Core" -display_name {AXI I3C Controller Core}]
  #Adding Group
  set General_Configuration [ipgui::add_group $IPINST -name "General Configuration" -parent ${I3C_Controller_Core}]
  set MAX_DEVS [ipgui::add_param $IPINST -name "MAX_DEVS" -parent ${General_Configuration}]
  set_property tooltip {[MAX_DEVS] Maximum number of peripherals in the bus, counting the controller} ${MAX_DEVS}
  set I2C_MOD [ipgui::add_param $IPINST -name "I2C_MOD" -parent ${General_Configuration} -widget comboBox]
  set_property tooltip {[I2C_MOD] Further divide (two power) open drain speed to achieve a lower I2C. Set 0 to achieve 1.56MHz at (clk=100MHz, Clock cycles per bit=8), 1 for 781kHz.} ${I2C_MOD}



}

proc update_PARAM_VALUE.I2C_MOD { PARAM_VALUE.I2C_MOD } {
	# Procedure called to update I2C_MOD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.I2C_MOD { PARAM_VALUE.I2C_MOD } {
	# Procedure called to validate I2C_MOD
	return true
}

proc update_PARAM_VALUE.MAX_DEVS { PARAM_VALUE.MAX_DEVS } {
	# Procedure called to update MAX_DEVS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_DEVS { PARAM_VALUE.MAX_DEVS } {
	# Procedure called to validate MAX_DEVS
	return true
}


proc update_MODELPARAM_VALUE.MAX_DEVS { MODELPARAM_VALUE.MAX_DEVS PARAM_VALUE.MAX_DEVS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_DEVS}] ${MODELPARAM_VALUE.MAX_DEVS}
}

proc update_MODELPARAM_VALUE.I2C_MOD { MODELPARAM_VALUE.I2C_MOD PARAM_VALUE.I2C_MOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.I2C_MOD}] ${MODELPARAM_VALUE.I2C_MOD}
}

