// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Tue Jun  7 12:20:30 2022
// Host        : DESKTOP-TV2T1SG running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/xilinx_proyectos/Laboratorios/lab2/lab2_ROM_generated/lab2_ROM_generated.srcs/sources_1/ip/blk_memB_gen_0/blk_memB_gen_0_stub.v
// Design      : blk_memB_gen_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_3,Vivado 2019.1" *)
module blk_memB_gen_0(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[2:0],douta[7:0]" */;
  input clka;
  input [2:0]addra;
  output [7:0]douta;
endmodule