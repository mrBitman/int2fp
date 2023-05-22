// @file:       cmp.sv
// @brief:      Just 2-1 compare module
// @author:     Oleg Bitman


module cmp
  import modules_params_pkg::*;
(
  input  logic                       cmp_type_i,  // 1 -> max_o, 0 -> min_o
  input  logic signed [WORD_LEN-1:0] x1_i,
  input  logic signed [WORD_LEN-1:0] x2_i,
  output logic signed [WORD_LEN-1:0] y_o
);

always_comb begin
  // In case at odd splitted cells to compare
  // first input signal passes to the output
  y_o = x1_i;
  if      (x2_i>x1_i) y_o = (cmp_type_i) ? x2_i : x1_i;
  else if (x2_i<x1_i) y_o = (cmp_type_i) ? x1_i : x2_i;
end
endmodule