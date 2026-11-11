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


`ifndef if_dma_ram_v1_0
`define if_dma_ram_v1_0

package parameter_structs;

  typedef struct packed {
      bit    portEnabled;
      integer    portWidth;
  }portConfig;

  typedef struct packed {
    // <typeName> <LogicalName> = {<enablement>, <width>}
    portConfig wr_cmd_sel;
    portConfig wr_cmd_be;
    portConfig wr_cmd_addr;
    portConfig wr_cmd_data;
    portConfig wr_cmd_valid;
    portConfig wr_cmd_ready;
    portConfig wr_done;
    portConfig rd_cmd_sel;
    portConfig rd_cmd_addr;
    portConfig rd_cmd_valid;
    portConfig rd_cmd_ready;
    portConfig rd_resp_data;
    portConfig rd_resp_valid;
    portConfig rd_resp_ready;
  }if_dma_ram_v1_0_port_configuration;

  parameter if_dma_ram_v1_0_port_configuration if_dma_ram_v1_0_default_port_configuration = '{wr_cmd_sel:'{1, -1}, wr_cmd_be:'{1, -1}, wr_cmd_addr:'{1, -1}, wr_cmd_data:'{1, -1}, wr_cmd_valid:'{1, -1}, wr_cmd_ready:'{1, -1}, wr_done:'{1, -1}, rd_cmd_sel:'{1, -1}, rd_cmd_addr:'{1, -1}, rd_cmd_valid:'{1, -1}, rd_cmd_ready:'{1, -1}, rd_resp_data:'{1, -1}, rd_resp_valid:'{1, -1}, rd_resp_ready:'{1, -1}};

endpackage

interface if_dma_ram_v1_0 #(parameter_structs::if_dma_ram_v1_0_port_configuration port_configuration)();
  logic [port_configuration.wr_cmd_sel.portWidth-1:0] wr_cmd_sel = 0;             // 
  logic [port_configuration.wr_cmd_be.portWidth-1:0] wr_cmd_be = 0;               // 
  logic [port_configuration.wr_cmd_addr.portWidth-1:0] wr_cmd_addr = 0;           // 
  logic [port_configuration.wr_cmd_data.portWidth-1:0] wr_cmd_data = 0;           // 
  logic [port_configuration.wr_cmd_valid.portWidth-1:0] wr_cmd_valid = 0;         // 
  logic [port_configuration.wr_cmd_ready.portWidth-1:0] wr_cmd_ready = 0;         // 
  logic [port_configuration.wr_done.portWidth-1:0] wr_done = 0;                   // 
  logic [port_configuration.rd_cmd_sel.portWidth-1:0] rd_cmd_sel = 0;             // 
  logic [port_configuration.rd_cmd_addr.portWidth-1:0] rd_cmd_addr = 0;           // 
  logic [port_configuration.rd_cmd_valid.portWidth-1:0] rd_cmd_valid = 0;         // 
  logic [port_configuration.rd_cmd_ready.portWidth-1:0] rd_cmd_ready = 0;         // 
  logic [port_configuration.rd_resp_data.portWidth-1:0] rd_resp_data = 0;         // 
  logic [port_configuration.rd_resp_valid.portWidth-1:0] rd_resp_valid = 0;       // 
  logic [port_configuration.rd_resp_ready.portWidth-1:0] rd_resp_ready = 0;       // 

  modport MASTER (
    input wr_cmd_sel, wr_cmd_be, wr_cmd_addr, wr_cmd_data, wr_cmd_valid, rd_cmd_sel, rd_cmd_addr, rd_cmd_valid, rd_resp_ready, 
    output wr_cmd_ready, wr_done, rd_cmd_ready, rd_resp_data, rd_resp_valid
    );

  modport SLAVE (
    input wr_cmd_ready, wr_done, rd_cmd_ready, rd_resp_data, rd_resp_valid, 
    output wr_cmd_sel, wr_cmd_be, wr_cmd_addr, wr_cmd_data, wr_cmd_valid, rd_cmd_sel, rd_cmd_addr, rd_cmd_valid, rd_resp_ready
    );

  modport MONITOR (
    input wr_cmd_sel, wr_cmd_be, wr_cmd_addr, wr_cmd_data, wr_cmd_valid, wr_cmd_ready, wr_done, rd_cmd_sel, rd_cmd_addr, rd_cmd_valid, rd_cmd_ready, rd_resp_data, rd_resp_valid, rd_resp_ready
    );

endinterface // if_dma_ram_v1_0

`endif