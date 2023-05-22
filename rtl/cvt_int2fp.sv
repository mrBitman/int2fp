// @file:       cvt_int2fp.sv
// @brief:      Parametrizable (single/half precision) converter signed int to fp(32/16)
// @author:     Oleg Bitman


module cvt_int2fp
  import modules_params_pkg::*;
#(
  parameter NUM_WORDS = 8
)(
  input   logic                        clk,
  input   logic         [WORD_LEN-1:0] int_i     [NUM_WORDS-1:0],

  output  logic                        fp_sign_o [NUM_WORDS-1:0],
  output  logic   [FP_EXP_WIDTH  -1:0] fp_exp_o  [NUM_WORDS-1:0],
  output  logic   [FP_MANT_WIDTH -1:0] fp_mant_o [NUM_WORDS-1:0]
);

// ---------------------------------------------------------------------------
// Local Declaration
// ---------------------------------------------------------------------------

logic      [WORD_LEN-2:0] int_abs_without_sign [NUM_WORDS-1:0];
logic      [WORD_LEN-2:0] ff_int_mask          [NUM_WORDS-1:0]; // Find first zero integer highest bits
logic      [WORD_LEN-2:0] ff_int_onehot        [NUM_WORDS-1:0];

logic                     sign_int      [NUM_WORDS-1:0];
logic  [FP_EXP_WIDTH-1:0] point_ptr     [NUM_WORDS-1:0];
logic  [FP_EXP_WIDTH-1:0] exponent_bias [NUM_WORDS-1:0];
logic  [FP_EXP_WIDTH-1:0] exponent_dec  [NUM_WORDS-1:0];

logic [FP_MANT_WIDTH-1:0] mantissa_prepare [NUM_WORDS-1:0];
logic [FP_MANT_WIDTH:  0] mantissa         [NUM_WORDS-1:0];

logic round      [NUM_WORDS-1:0];
logic last_bit   [NUM_WORDS-1:0];
logic guard_bit  [NUM_WORDS-1:0];
logic sticky_bit [NUM_WORDS-1:0];

logic                       fp_sign [NUM_WORDS-1:0];
logic   [FP_EXP_WIDTH -1:0] fp_exp  [NUM_WORDS-1:0];
logic   [FP_MANT_WIDTH-1:0] fp_mant [NUM_WORDS-1:0];

logic [FP_FORMAT_WIDTH-1:0] fp_res [NUM_WORDS-1:0];


// ---------------------------------------------------------------------------
// Main Code
// ---------------------------------------------------------------------------

// There are NUM_WORDS int2fp converters working in parallel
generate
  for (genvar word_idx = 0; word_idx < NUM_WORDS; word_idx++) begin : g_convertion

    assign sign_int[word_idx] = int_i[word_idx][WORD_LEN-1];

    assign int_abs_without_sign[word_idx] = sign_int[word_idx] ? ~int_i[word_idx] + (WORD_LEN-2)'(1)
                                                               :  int_i[word_idx];

    // Find-first (mask of int_i[word_idx] zeros and 1 bit)
    for (genvar ii = 0; ii < WORD_LEN-1; ii++) begin :g_test
      always_comb begin
        ff_int_mask[word_idx][ii]  = 1'b1;
        for (integer jj = ii+1; jj < WORD_LEN-1; jj++) begin
          // ii = 10 -> jj bits analyses range -> [10 ... 14]
          ff_int_mask[word_idx][ii] &= ~int_abs_without_sign[word_idx][jj];
        end
      end
        assign ff_int_onehot[word_idx][ii] = ff_int_mask[word_idx][ii] & int_abs_without_sign[word_idx][ii];
    end

    // Found value of shift for calculation exponent (int2onehot)
    always_comb begin
      point_ptr[word_idx]  = FP_EXP_WIDTH'(FP_FORMAT_WIDTH-1); // If onehot is zero - it means no mantissa bit is found. point_ptr = fp_len-1
      for (integer  ii = 0; ii < WORD_LEN-1; ii++) begin
        if(ff_int_onehot[word_idx][ii])
          point_ptr[word_idx] = FP_EXP_WIDTH'(ii);
      end
    end

    // Rounding
    // |-------------------------------------------|
    // |                   int_i                   |
    // |-------------------------------------------|
    // |        | FP_MANT_WIDTH-1:0 |              |
    // |-------------------------------------------|
    // |        |     Mantissa      |              |
    // |-------------------------------------------|
    // |                         |lb|gb|sticky bits|
    // |-------------------------------------------|
    // round = gb & (lb|sb)
    always_comb begin
      last_bit  [word_idx] = 1'b0;
      guard_bit [word_idx] = 1'b0;
      sticky_bit[word_idx] = 1'b0;
      round     [word_idx] = 1'b0;
      if(point_ptr[word_idx] > FP_MANT_WIDTH) begin
        last_bit  [word_idx] = int_abs_without_sign[word_idx][point_ptr[word_idx] - FP_MANT_WIDTH];
        guard_bit [word_idx] = int_abs_without_sign[word_idx][point_ptr[word_idx] - FP_MANT_WIDTH - 1];
        sticky_bit[word_idx] = |(int_abs_without_sign[word_idx] << (FP_FORMAT_WIDTH - (point_ptr[word_idx] - FP_MANT_WIDTH)));
        round     [word_idx] = guard_bit[word_idx] & (last_bit[word_idx] | sticky_bit[word_idx]);
      end
    end

    // If point_ptr > FP_MANT_WIDTH we need to shift full_mantissa bits to to cut off the extra bits
    assign mantissa_prepare[word_idx] = (int_abs_without_sign[word_idx] >> (point_ptr[word_idx] - FP_MANT_WIDTH));

    assign mantissa[word_idx] = (point_ptr[word_idx] > FP_MANT_WIDTH) ? mantissa_prepare[word_idx]
                                                                      + FP_MANT_WIDTH'(round[word_idx] & ROUND_MODE)
                                                                      : int_abs_without_sign[word_idx] << (FP_MANT_WIDTH - point_ptr[word_idx]);

    // Taking into account exponent overflow in cause of round-up
    assign exponent_dec[word_idx] = (point_ptr[word_idx] > FP_MANT_WIDTH) ? point_ptr[word_idx] + mantissa[word_idx][FP_MANT_WIDTH]
                                                                          : point_ptr[word_idx];

    // If round-up - taking into account mantissa overflow
    assign exponent_bias[word_idx] = (ROUND_MODE) ? FP_EXP_BIAS + exponent_dec[word_idx]
                                                  : FP_EXP_BIAS + point_ptr[word_idx];

    always_comb begin
      fp_sign[word_idx] = sign_int[word_idx];
      fp_exp [word_idx] = 'x;
      fp_mant[word_idx] = 'x;

      if (~|int_i[word_idx]) begin // Convert from zero
          fp_exp [word_idx] = {FP_EXP_WIDTH{1'b0}};
          fp_mant[word_idx] = {FP_MANT_WIDTH{1'b0}};
      end else begin
          fp_exp [word_idx] = exponent_bias[word_idx];
          fp_mant[word_idx] = mantissa[word_idx][FP_MANT_WIDTH -1:0];
      end
    end

    assign fp_res[word_idx] = {fp_sign[word_idx], fp_exp[word_idx], fp_mant[word_idx]};
  end
endgenerate

// Output assignment
generate
  for (genvar word_idx = 0; word_idx < NUM_WORDS; word_idx++) begin : g_out
    assign fp_sign_o[word_idx] = fp_sign[word_idx];
    assign fp_exp_o [word_idx] = fp_exp [word_idx];
    assign fp_mant_o[word_idx] = fp_mant[word_idx];
  end
endgenerate

endmodule