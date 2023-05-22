// @file:       modules_params_pkg.sv
// @brief:      fp16, fp32 parameters package
// @author:     Oleg Bitman


package modules_params_pkg;

// `define FP_32;
// fp32_o (Single Pressision FP)
// |   1  |   30:23  |     22:0     |
// |--------------------------------|
// | Sign | Exponent | Significand  |
// |--------------------------------|
// |             31:0               |

`define FP_16;
// fp16_o (Half Pressision FP)
// |   1  |   14:10  |     9:0      |
// |--------------------------------|
// | Sign | Exponent | Significand  |
// |--------------------------------|
// |             15:0               |

`ifdef FP_32
    localparam ROUND_MODE = 1'b1;                               // By default, rounds up, instead of down like double precision, because of the even number of bits in the significand

    localparam FP_FORMAT_WIDTH = 32;                            // Width of Single Pressision (SP) fp format
    localparam FP_EXP_WIDTH    = 8;                             // Width of exponent field in SP
    localparam FP_MANT_WIDTH   = 23;                            // Width of significand (mantissa) field in SP
    localparam FP_EXP_BIAS     = FP_EXP_WIDTH'(127);            // Bias for exponent in SP format

    localparam WORD_LEN        = FP_FORMAT_WIDTH;               // Word length
    localparam MAX_INT_VAL     = FP_FORMAT_WIDTH'('h7fff_ffff);
    localparam MIN_INT_VAL     = FP_FORMAT_WIDTH'('h8000_0000);

`elsif FP_16
    localparam ROUND_MODE = 1'b0;                               // By default, rounds down like for double precision, because of the odd number of bits in the significand

    localparam FP_FORMAT_WIDTH = 16;
    localparam FP_EXP_WIDTH    = 5;
    localparam FP_MANT_WIDTH   = 10;
    localparam FP_EXP_BIAS     = FP_EXP_WIDTH'(15);

    localparam WORD_LEN        = FP_FORMAT_WIDTH;

    localparam MAX_INT_VAL     = FP_FORMAT_WIDTH'('h7fff);
    localparam MIN_INT_VAL     = FP_FORMAT_WIDTH'('h8000);

`endif

endpackage