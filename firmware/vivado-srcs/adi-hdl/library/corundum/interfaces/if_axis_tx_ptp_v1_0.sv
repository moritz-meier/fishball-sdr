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


`ifndef if_axis_tx_ptp_v1_0
`define if_axis_tx_ptp_v1_0

package parameter_structs;

  typedef struct packed {
      bit    portEnabled;
      integer    portWidth;
  }portConfig;

  typedef struct packed {
    // <typeName> <LogicalName> = {<enablement>, <width>}
    portConfig ts;
    portConfig tag;
    portConfig valid;
    portConfig ready;
  }if_axis_tx_ptp_v1_0_port_configuration;

  parameter if_axis_tx_ptp_v1_0_port_configuration if_axis_tx_ptp_v1_0_default_port_configuration = '{ts:'{1, -1}, tag:'{1, -1}, valid:'{1, -1}, ready:'{1, -1}};

endpackage

interface if_axis_tx_ptp_v1_0 #(parameter_structs::if_axis_tx_ptp_v1_0_port_configuration port_configuration)();
  logic [port_configuration.ts.portWidth-1:0] ts = 0;             // 
  logic [port_configuration.tag.portWidth-1:0] tag = 0;           // 
  logic [port_configuration.valid.portWidth-1:0] valid = 0;       // 
  logic [port_configuration.ready.portWidth-1:0] ready = 0;       // 

  modport MASTER (
    input ts, tag, valid, 
    output ready
    );

  modport SLAVE (
    input ready, 
    output ts, tag, valid
    );

  modport MONITOR (
    input ts, tag, valid, ready
    );

endinterface // if_axis_tx_ptp_v1_0

`endif