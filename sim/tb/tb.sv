// @file:       tb.sv
// @brief:      Testbanch int2fp - fp2int_cmp conversion (fp16 or fp32)
// @author:     Oleg Bitman


`timescale 1ns/1ps

`include "../rtl/cvt_int2fp.sv"
`include "../rtl/cvt_cmp_fp2int.sv"
`include "../rtl/modules_params_pkg.sv"
`include "../rtl/cmp.sv"

module tb
import modules_params_pkg::*; // Import everything from modules_params_pkg
(
);

localparam NUM_WORDS = 8; // Quantity of words to convert

logic clk;
logic rst_n;

logic        [WORD_LEN-1:0] int_value_next [NUM_WORDS-1:0];
logic        [WORD_LEN-1:0] int_value_ff   [NUM_WORDS-1:0];

logic                       fp_sign [NUM_WORDS-1:0];
logic  [FP_EXP_WIDTH  -1:0] fp_exp  [NUM_WORDS-1:0];
logic  [FP_MANT_WIDTH -1:0] fp_mant [NUM_WORDS-1:0];
logic        [WORD_LEN-1:0] err2conv [NUM_WORDS-1:0];

logic                       cmp_type;
logic                       res_comp_int_en;
logic        [WORD_LEN-1:0] re_comp_int;

localparam READ_DEPTH = 100;
int file0, count_rd, rd_status0;
event reset_done;

// 1: max_int_o
// 0: min_int_o
assign cmp_type = 1'b1;

initial begin
  clk = '0;
  forever #5 clk = ~clk;
end

initial begin
  rst_n = 1'b0;
  @(posedge clk);
  rst_n = 1'b1;
  -> reset_done;
  repeat (READ_DEPTH) @(posedge clk); $finish;
end

// Read .txt data
initial begin
  @ (reset_done); @(negedge clk) // Wait one negedge, then start

  file0 = $fopen("tb_data/int_values.txt", "r");

  for(count_rd = 0; count_rd < READ_DEPTH; count_rd++ ) begin
    rd_status0 = $fscanf(file0,"'{'h%h, 'h%h, 'h%h, 'h%h, 'h%h, 'h%h, 'h%h, 'h%h} ", int_value_next[7], int_value_next[6], int_value_next[5], int_value_next[4], int_value_next[3], int_value_next[2], int_value_next[1], int_value_next[0]);
    @ (negedge clk); // Read at the negedge, then snap these values on the trigger
  end

  $fclose(file0);
  $display("file has been successfully read");
end

always_ff @(posedge clk or negedge rst_n) begin
  if(~rst_n)
    int_value_ff <= '{NUM_WORDS{0}};
  else
    int_value_ff <= int_value_next;
end

// Error due to conversion:
// https://evanw.github.io/float-toy/ - int<->fp converter
generate
  for (genvar word_idx = 0; word_idx < NUM_WORDS; word_idx++) begin : g_err2conv
    assign err2conv[word_idx] = (tb.i_cvt_cmp_fp2int.int_valid[word_idx]) ? tb.i_cvt_cmp_fp2int.int_field_full[word_idx]
                                                                          - int_value_ff[word_idx]
                                                                          : 'x;
  end
endgenerate

cvt_int2fp #(
  .NUM_WORDS(NUM_WORDS)
) i_cvt_int2fp (
  .clk       (clk),
  .int_i     (int_value_ff),
  .fp_sign_o (fp_sign),
  .fp_exp_o  (fp_exp),
  .fp_mant_o (fp_mant)
);

cvt_cmp_fp2int #(
  .NUM_WORDS(NUM_WORDS)
) i_cvt_cmp_fp2int (
  .clk           (clk),
  .cmp_type_i    (cmp_type),
  .fp_sign_i     (fp_sign),
  .fp_exp_i      (fp_exp),
  .fp_mant_i     (fp_mant),
  .comp_int_en_o (res_comp_int_en),
  .comp_int_o    (re_comp_int)
);

endmodule