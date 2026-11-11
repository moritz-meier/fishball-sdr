# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set I3C_Controller_Host_Interface [ipgui::add_page $IPINST -name "I3C Controller Host Interface" -display_name {AXI I3C Controller Host Interface}]
  #Adding Group
  set General_Configuration [ipgui::add_group $IPINST -name "General Configuration" -parent ${I3C_Controller_Host_Interface}]
  set ID [ipgui::add_param $IPINST -name "ID" -parent ${General_Configuration}]
  set_property tooltip {[ID] Core instance ID} ${ID}
  set ASYNC_CLK [ipgui::add_param $IPINST -name "ASYNC_CLK" -parent ${General_Configuration}]
  set_property tooltip {[ASYNC_CLK] Define the relationship between the core clock and the memory mapped interface clock} ${ASYNC_CLK}
  set OFFLOAD [ipgui::add_param $IPINST -name "OFFLOAD" -parent ${General_Configuration}]
  set_property tooltip {[OFFLOAD] Allows to offload output data to a external receiver, like a DMA} ${OFFLOAD}

  #Adding Group
  set Command_stream_FIFO_configuration [ipgui::add_group $IPINST -name "Command stream FIFO configuration" -parent ${I3C_Controller_Host_Interface}]
  set CMD_FIFO_ADDRESS_WIDTH [ipgui::add_param $IPINST -name "CMD_FIFO_ADDRESS_WIDTH" -parent ${Command_stream_FIFO_configuration}]
  set_property tooltip {[CMD_FIFO_ADDRESS_WIDTH] Define the depth of the FIFO} ${CMD_FIFO_ADDRESS_WIDTH}
  set CMDR_FIFO_ADDRESS_WIDTH [ipgui::add_param $IPINST -name "CMDR_FIFO_ADDRESS_WIDTH" -parent ${Command_stream_FIFO_configuration}]
  set_property tooltip {[CMDR_FIFO_ADDRESS_WIDTH] Define the depth of the FIFO} ${CMDR_FIFO_ADDRESS_WIDTH}
  set SDO_FIFO_ADDRESS_WIDTH [ipgui::add_param $IPINST -name "SDO_FIFO_ADDRESS_WIDTH" -parent ${Command_stream_FIFO_configuration}]
  set_property tooltip {[SDO_FIFO_ADDRESS_WIDTH] Define the depth of the FIFO} ${SDO_FIFO_ADDRESS_WIDTH}
  set SDI_FIFO_ADDRESS_WIDTH [ipgui::add_param $IPINST -name "SDI_FIFO_ADDRESS_WIDTH" -parent ${Command_stream_FIFO_configuration}]
  set_property tooltip {[IBI_FIFO_ADDRESS_WIDTH] Define the depth of the FIFO} ${SDI_FIFO_ADDRESS_WIDTH}
  ipgui::add_param $IPINST -name "IBI_FIFO_ADDRESS_WIDTH" -parent ${Command_stream_FIFO_configuration}

  #Adding Group
  set Provisioned_ID_and_dynamic_address_configuration [ipgui::add_group $IPINST -name "Provisioned ID and dynamic address configuration" -parent ${I3C_Controller_Host_Interface}]
  set DA [ipgui::add_param $IPINST -name "DA" -parent ${Provisioned_ID_and_dynamic_address_configuration}]
  set_property tooltip {[DA] Controller dynamic address, used only for conformity, has no effect.} ${DA}
  set PID_MANUF_ID [ipgui::add_param $IPINST -name "PID_MANUF_ID" -parent ${Provisioned_ID_and_dynamic_address_configuration}]
  set_property tooltip {[PID_MANUF_ID] MIPI Manufacturer ID} ${PID_MANUF_ID}
  set PID_TYPE_SELECTOR [ipgui::add_param $IPINST -name "PID_TYPE_SELECTOR" -parent ${Provisioned_ID_and_dynamic_address_configuration}]
  set_property tooltip {[PID_TYPE_SELECTOR] 1'b1: Random Value, 1'b0: Vendor Fixed Value} ${PID_TYPE_SELECTOR}
  set PID_PART_ID [ipgui::add_param $IPINST -name "PID_PART_ID" -parent ${Provisioned_ID_and_dynamic_address_configuration}]
  set_property tooltip {[PID_PART_ID] Device identifier, use the same for all instances of this controller} ${PID_PART_ID}
  set PID_INSTANCE_ID [ipgui::add_param $IPINST -name "PID_INSTANCE_ID" -parent ${Provisioned_ID_and_dynamic_address_configuration}]
  set_property tooltip {[PID_INSTANCE_ID] Identify the individual device} ${PID_INSTANCE_ID}
  set PID_EXTRA_ID [ipgui::add_param $IPINST -name "PID_EXTRA_ID" -parent ${Provisioned_ID_and_dynamic_address_configuration}]
  set_property tooltip {[PID_EXTRA_ID] Extra characteristics field} ${PID_EXTRA_ID}



}

proc update_PARAM_VALUE.ASYNC_CLK { PARAM_VALUE.ASYNC_CLK } {
	# Procedure called to update ASYNC_CLK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ASYNC_CLK { PARAM_VALUE.ASYNC_CLK } {
	# Procedure called to validate ASYNC_CLK
	return true
}

proc update_PARAM_VALUE.CMDR_FIFO_ADDRESS_WIDTH { PARAM_VALUE.CMDR_FIFO_ADDRESS_WIDTH } {
	# Procedure called to update CMDR_FIFO_ADDRESS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CMDR_FIFO_ADDRESS_WIDTH { PARAM_VALUE.CMDR_FIFO_ADDRESS_WIDTH } {
	# Procedure called to validate CMDR_FIFO_ADDRESS_WIDTH
	return true
}

proc update_PARAM_VALUE.CMD_FIFO_ADDRESS_WIDTH { PARAM_VALUE.CMD_FIFO_ADDRESS_WIDTH } {
	# Procedure called to update CMD_FIFO_ADDRESS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CMD_FIFO_ADDRESS_WIDTH { PARAM_VALUE.CMD_FIFO_ADDRESS_WIDTH } {
	# Procedure called to validate CMD_FIFO_ADDRESS_WIDTH
	return true
}

proc update_PARAM_VALUE.DA { PARAM_VALUE.DA } {
	# Procedure called to update DA when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DA { PARAM_VALUE.DA } {
	# Procedure called to validate DA
	return true
}

proc update_PARAM_VALUE.IBI_FIFO_ADDRESS_WIDTH { PARAM_VALUE.IBI_FIFO_ADDRESS_WIDTH } {
	# Procedure called to update IBI_FIFO_ADDRESS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IBI_FIFO_ADDRESS_WIDTH { PARAM_VALUE.IBI_FIFO_ADDRESS_WIDTH } {
	# Procedure called to validate IBI_FIFO_ADDRESS_WIDTH
	return true
}

proc update_PARAM_VALUE.ID { PARAM_VALUE.ID } {
	# Procedure called to update ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ID { PARAM_VALUE.ID } {
	# Procedure called to validate ID
	return true
}

proc update_PARAM_VALUE.OFFLOAD { PARAM_VALUE.OFFLOAD } {
	# Procedure called to update OFFLOAD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OFFLOAD { PARAM_VALUE.OFFLOAD } {
	# Procedure called to validate OFFLOAD
	return true
}

proc update_PARAM_VALUE.PID_EXTRA_ID { PARAM_VALUE.PID_EXTRA_ID } {
	# Procedure called to update PID_EXTRA_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PID_EXTRA_ID { PARAM_VALUE.PID_EXTRA_ID } {
	# Procedure called to validate PID_EXTRA_ID
	return true
}

proc update_PARAM_VALUE.PID_INSTANCE_ID { PARAM_VALUE.PID_INSTANCE_ID } {
	# Procedure called to update PID_INSTANCE_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PID_INSTANCE_ID { PARAM_VALUE.PID_INSTANCE_ID } {
	# Procedure called to validate PID_INSTANCE_ID
	return true
}

proc update_PARAM_VALUE.PID_MANUF_ID { PARAM_VALUE.PID_MANUF_ID } {
	# Procedure called to update PID_MANUF_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PID_MANUF_ID { PARAM_VALUE.PID_MANUF_ID } {
	# Procedure called to validate PID_MANUF_ID
	return true
}

proc update_PARAM_VALUE.PID_PART_ID { PARAM_VALUE.PID_PART_ID } {
	# Procedure called to update PID_PART_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PID_PART_ID { PARAM_VALUE.PID_PART_ID } {
	# Procedure called to validate PID_PART_ID
	return true
}

proc update_PARAM_VALUE.PID_TYPE_SELECTOR { PARAM_VALUE.PID_TYPE_SELECTOR } {
	# Procedure called to update PID_TYPE_SELECTOR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PID_TYPE_SELECTOR { PARAM_VALUE.PID_TYPE_SELECTOR } {
	# Procedure called to validate PID_TYPE_SELECTOR
	return true
}

proc update_PARAM_VALUE.SDI_FIFO_ADDRESS_WIDTH { PARAM_VALUE.SDI_FIFO_ADDRESS_WIDTH } {
	# Procedure called to update SDI_FIFO_ADDRESS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SDI_FIFO_ADDRESS_WIDTH { PARAM_VALUE.SDI_FIFO_ADDRESS_WIDTH } {
	# Procedure called to validate SDI_FIFO_ADDRESS_WIDTH
	return true
}

proc update_PARAM_VALUE.SDO_FIFO_ADDRESS_WIDTH { PARAM_VALUE.SDO_FIFO_ADDRESS_WIDTH } {
	# Procedure called to update SDO_FIFO_ADDRESS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SDO_FIFO_ADDRESS_WIDTH { PARAM_VALUE.SDO_FIFO_ADDRESS_WIDTH } {
	# Procedure called to validate SDO_FIFO_ADDRESS_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.CMD_FIFO_ADDRESS_WIDTH { MODELPARAM_VALUE.CMD_FIFO_ADDRESS_WIDTH PARAM_VALUE.CMD_FIFO_ADDRESS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CMD_FIFO_ADDRESS_WIDTH}] ${MODELPARAM_VALUE.CMD_FIFO_ADDRESS_WIDTH}
}

proc update_MODELPARAM_VALUE.CMDR_FIFO_ADDRESS_WIDTH { MODELPARAM_VALUE.CMDR_FIFO_ADDRESS_WIDTH PARAM_VALUE.CMDR_FIFO_ADDRESS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CMDR_FIFO_ADDRESS_WIDTH}] ${MODELPARAM_VALUE.CMDR_FIFO_ADDRESS_WIDTH}
}

proc update_MODELPARAM_VALUE.SDO_FIFO_ADDRESS_WIDTH { MODELPARAM_VALUE.SDO_FIFO_ADDRESS_WIDTH PARAM_VALUE.SDO_FIFO_ADDRESS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SDO_FIFO_ADDRESS_WIDTH}] ${MODELPARAM_VALUE.SDO_FIFO_ADDRESS_WIDTH}
}

proc update_MODELPARAM_VALUE.SDI_FIFO_ADDRESS_WIDTH { MODELPARAM_VALUE.SDI_FIFO_ADDRESS_WIDTH PARAM_VALUE.SDI_FIFO_ADDRESS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SDI_FIFO_ADDRESS_WIDTH}] ${MODELPARAM_VALUE.SDI_FIFO_ADDRESS_WIDTH}
}

proc update_MODELPARAM_VALUE.IBI_FIFO_ADDRESS_WIDTH { MODELPARAM_VALUE.IBI_FIFO_ADDRESS_WIDTH PARAM_VALUE.IBI_FIFO_ADDRESS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IBI_FIFO_ADDRESS_WIDTH}] ${MODELPARAM_VALUE.IBI_FIFO_ADDRESS_WIDTH}
}

proc update_MODELPARAM_VALUE.ID { MODELPARAM_VALUE.ID PARAM_VALUE.ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ID}] ${MODELPARAM_VALUE.ID}
}

proc update_MODELPARAM_VALUE.DA { MODELPARAM_VALUE.DA PARAM_VALUE.DA } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DA}] ${MODELPARAM_VALUE.DA}
}

proc update_MODELPARAM_VALUE.ASYNC_CLK { MODELPARAM_VALUE.ASYNC_CLK PARAM_VALUE.ASYNC_CLK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ASYNC_CLK}] ${MODELPARAM_VALUE.ASYNC_CLK}
}

proc update_MODELPARAM_VALUE.OFFLOAD { MODELPARAM_VALUE.OFFLOAD PARAM_VALUE.OFFLOAD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OFFLOAD}] ${MODELPARAM_VALUE.OFFLOAD}
}

proc update_MODELPARAM_VALUE.PID_MANUF_ID { MODELPARAM_VALUE.PID_MANUF_ID PARAM_VALUE.PID_MANUF_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PID_MANUF_ID}] ${MODELPARAM_VALUE.PID_MANUF_ID}
}

proc update_MODELPARAM_VALUE.PID_TYPE_SELECTOR { MODELPARAM_VALUE.PID_TYPE_SELECTOR PARAM_VALUE.PID_TYPE_SELECTOR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PID_TYPE_SELECTOR}] ${MODELPARAM_VALUE.PID_TYPE_SELECTOR}
}

proc update_MODELPARAM_VALUE.PID_PART_ID { MODELPARAM_VALUE.PID_PART_ID PARAM_VALUE.PID_PART_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PID_PART_ID}] ${MODELPARAM_VALUE.PID_PART_ID}
}

proc update_MODELPARAM_VALUE.PID_INSTANCE_ID { MODELPARAM_VALUE.PID_INSTANCE_ID PARAM_VALUE.PID_INSTANCE_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PID_INSTANCE_ID}] ${MODELPARAM_VALUE.PID_INSTANCE_ID}
}

proc update_MODELPARAM_VALUE.PID_EXTRA_ID { MODELPARAM_VALUE.PID_EXTRA_ID PARAM_VALUE.PID_EXTRA_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PID_EXTRA_ID}] ${MODELPARAM_VALUE.PID_EXTRA_ID}
}

