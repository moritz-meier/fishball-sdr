// (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// (c) Copyright 2022-2026 Advanced Micro Devices, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


`ifndef if_flow_control_rx_v1_0
`define if_flow_control_rx_v1_0

package parameter_structs;

  typedef struct packed {
      bit    portEnabled;
      integer    portWidth;
  }portConfig;

  typedef struct packed {
    // <typeName> <LogicalName> = {<enablement>, <width>}
    portConfig rx_enable;
    portConfig rx_status;
    portConfig rx_lfc_en;
    portConfig rx_lfc_req;
    portConfig rx_lfc_ack;
    portConfig rx_pfc_en;
    portConfig rx_pfc_req;
    portConfig rx_pfc_ack;
    portConfig rx_fc_quanta_clk_en;
  }if_flow_control_rx_v1_0_port_configuration;

  parameter if_flow_control_rx_v1_0_port_configuration if_flow_control_rx_v1_0_default_port_configuration = '{rx_enable:'{1, -1}, rx_status:'{1, -1}, rx_lfc_en:'{1, -1}, rx_lfc_req:'{1, -1}, rx_lfc_ack:'{1, -1}, rx_pfc_en:'{1, -1}, rx_pfc_req:'{1, -1}, rx_pfc_ack:'{1, -1}, rx_fc_quanta_clk_en:'{1, -1}};

endpackage

interface if_flow_control_rx_v1_0 #(parameter_structs::if_flow_control_rx_v1_0_port_configuration port_configuration)();
  logic [port_configuration.rx_enable.portWidth-1:0] rx_enable = 0;                           // 
  logic [port_configuration.rx_status.portWidth-1:0] rx_status = 0;                           // 
  logic [port_configuration.rx_lfc_en.portWidth-1:0] rx_lfc_en = 0;                           // 
  logic [port_configuration.rx_lfc_req.portWidth-1:0] rx_lfc_req = 0;                         // 
  logic [port_configuration.rx_lfc_ack.portWidth-1:0] rx_lfc_ack = 0;                         // 
  logic [port_configuration.rx_pfc_en.portWidth-1:0] rx_pfc_en = 0;                           // 
  logic [port_configuration.rx_pfc_req.portWidth-1:0] rx_pfc_req = 0;                         // 
  logic [port_configuration.rx_pfc_ack.portWidth-1:0] rx_pfc_ack = 0;                         // 
  logic [port_configuration.rx_fc_quanta_clk_en.portWidth-1:0] rx_fc_quanta_clk_en = 0;       // 

  modport MASTER (
    input rx_status, rx_lfc_req, rx_pfc_req, rx_fc_quanta_clk_en, 
    output rx_enable, rx_lfc_en, rx_lfc_ack, rx_pfc_en, rx_pfc_ack
    );

  modport SLAVE (
    input rx_enable, rx_lfc_en, rx_lfc_ack, rx_pfc_en, rx_pfc_ack, 
    output rx_status, rx_lfc_req, rx_pfc_req, rx_fc_quanta_clk_en
    );

  modport MONITOR (
    input rx_enable, rx_status, rx_lfc_en, rx_lfc_req, rx_lfc_ack, rx_pfc_en, rx_pfc_req, rx_pfc_ack, rx_fc_quanta_clk_en
    );

endinterface // if_flow_control_rx_v1_0

`endif