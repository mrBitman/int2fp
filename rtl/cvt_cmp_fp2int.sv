// @file:       cvt_cmp_fp2int.sv
// @brief:      Parametrizable (single/half precision) converter fp(32/16) to signed integer, that issues smaller or biggest converted value
// @author:     Oleg Bitman


module cvt_cmp_fp2int
  import modules_params_pkg::*;
#(
  parameter NUM_WORDS = 8
)(
  input  logic                      clk,
  input  logic                      cmp_type_i, // 1 - max_int_o, 0 - min_int_o

  input  logic                      fp_sign_i [NUM_WORDS-1:0],
  input  logic [FP_EXP_WIDTH  -1:0] fp_exp_i  [NUM_WORDS-1:0],
  input  logic [FP_MANT_WIDTH -1:0] fp_mant_i [NUM_WORDS-1:0],

  output logic                      comp_int_en_o,
  output logic       [WORD_LEN-1:0] comp_int_o
);

// ---------------------------------------------------------------------------
// Local Declaration
// ---------------------------------------------------------------------------

localparam NUM_WORD_ROUND = (NUM_WORDS%2) ? NUM_WORDS+1
                                          : NUM_WORDS;

localparam MAX_WORD_DEPTH = NUM_WORD_ROUND/2;

localparam COMPARATION_DEPTH = $clog2(MAX_WORD_DEPTH)+1;

logic int_sign  [NUM_WORDS-1:0];

logic inf_flag  [NUM_WORDS-1:0];
logic nan_flag  [NUM_WORDS-1:0];
logic zero_flag [NUM_WORDS-1:0];
logic int_valid [NUM_WORDS-1:0];

logic [FP_EXP_WIDTH-1:0] point_ptr      [NUM_WORDS-1:0];
logic     [WORD_LEN-2:0] int_abs        [NUM_WORDS-1:0];
logic     [WORD_LEN-2:0] int_two_compl  [NUM_WORDS-1:0];
logic     [WORD_LEN-1:0] int_field_full [NUM_WORDS-1:0];
logic     [WORD_LEN-1:0] int_conv       [NUM_WORDS-1:0];

logic     [WORD_LEN-1:0] tmp_arr [COMPARATION_DEPTH-1:0][MAX_WORD_DEPTH-1:0];

logic                    comp_int_en;
logic     [WORD_LEN-1:0] comp_int;

// ---------------------------------------------------------------------------
// Main Code
// ---------------------------------------------------------------------------

// There are NUM_WORDS fp2int converters working in parallel
generate
  for (genvar word_idx = 0; word_idx < NUM_WORDS; word_idx++) begin : g_convertion

    assign int_sign [word_idx] = fp_sign_i[word_idx];
    assign nan_flag [word_idx] = (&fp_exp_i[word_idx])  & (|fp_mant_i[word_idx]);  // exp = all'1, mant = Non-zero
    assign zero_flag[word_idx] = (~|fp_exp_i[word_idx]) & (~|fp_mant_i[word_idx]); // exp = all'0, mant = all'0
    assign inf_flag [word_idx] = (&fp_exp_i[word_idx])  & (~|fp_mant_i[word_idx]); // exp = all'1, mant = all'0

    assign int_valid[word_idx] = ~nan_flag[word_idx];

    assign point_ptr[word_idx] = fp_exp_i[word_idx] - FP_EXP_BIAS;

    assign int_abs[word_idx] = (point_ptr[word_idx] > FP_MANT_WIDTH)  ? {1'b1,fp_mant_i[word_idx]} << (point_ptr[word_idx] - FP_MANT_WIDTH)
                                                                      : {1'b1,fp_mant_i[word_idx]} >> (FP_MANT_WIDTH - point_ptr[word_idx]);

    assign int_two_compl[word_idx] = int_sign[word_idx] ? ~int_abs[word_idx] + (WORD_LEN-2)'(1)
                                                        :  int_abs[word_idx];

    assign int_field_full[word_idx] = {int_sign[word_idx], int_two_compl[word_idx]};

    always_comb begin
      int_conv[word_idx] = WORD_LEN'(0);
      // Convert from zero
      if (zero_flag[word_idx]) begin
          int_conv[word_idx] = WORD_LEN'(0);
      // Convert from inf
      end else if (inf_flag[word_idx]) begin
          int_conv[word_idx] = int_sign[word_idx] ? MIN_INT_VAL
                                                  : MAX_INT_VAL;
      end else begin
          int_conv[word_idx] = int_field_full[word_idx];
      end
    end
  end
endgenerate

always_comb begin
  comp_int_en = 1'b0;
  for (integer word_idx = 0; word_idx < NUM_WORDS; word_idx++) begin : g_convertion
      comp_int_en |= int_valid[word_idx];
  end
end

// Finding larger / smaller int
generate
  for (genvar stg_idx = 0; stg_idx < MAX_WORD_DEPTH; stg_idx++) begin : g_init // Initialization tmp_arr[0] by converted values
    cmp i_cmp (
      .cmp_type_i(cmp_type_i),
      .x1_i(int_conv[2*stg_idx]),
      .x2_i(int_conv[2*stg_idx+1]),
      .y_o(tmp_arr[0][stg_idx])
      );
  end

  for (genvar stg_idx = 0; stg_idx < COMPARATION_DEPTH; stg_idx++) begin : g_sort_lvl // Depth of sorting (Quantity stages)
    for (genvar cmp_idx = 0; cmp_idx < MAX_WORD_DEPTH/2**stg_idx; cmp_idx++) begin : g_cmp // Quantity of comparators on this stage
      cmp i_cmp (
          .cmp_type_i(cmp_type_i),
          .x1_i(tmp_arr[stg_idx][2*cmp_idx]),
          .x2_i(tmp_arr[stg_idx][2*cmp_idx+1]),
          .y_o(tmp_arr[stg_idx+1][cmp_idx])
          );
      end
  end

  assign comp_int = tmp_arr[COMPARATION_DEPTH-1][0];

endgenerate

// Output assignment
assign comp_int_o = comp_int;
assign comp_int_en_o = comp_int_en;

endmodule