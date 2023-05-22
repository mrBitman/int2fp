onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /modules_params_pkg::WORD_LEN
add wave -noupdate -radix decimal -radixshowbase 1 /tb/NUM_WORDS
add wave -noupdate -divider {input int}
add wave -noupdate -color Coral -radix decimal -childformat {{{/tb/int_value_ff[7]} -radix decimal} {{/tb/int_value_ff[6]} -radix decimal} {{/tb/int_value_ff[5]} -radix decimal} {{/tb/int_value_ff[4]} -radix decimal} {{/tb/int_value_ff[3]} -radix decimal} {{/tb/int_value_ff[2]} -radix decimal} {{/tb/int_value_ff[1]} -radix decimal} {{/tb/int_value_ff[0]} -radix decimal}} -radixshowbase 0 -expand -subitemconfig {{/tb/int_value_ff[7]} {-color Coral -height 23 -radix decimal -radixshowbase 0} {/tb/int_value_ff[6]} {-color Coral -height 23 -radix decimal -radixshowbase 0} {/tb/int_value_ff[5]} {-color Coral -height 23 -radix decimal -radixshowbase 0} {/tb/int_value_ff[4]} {-color Coral -height 23 -radix decimal -radixshowbase 0} {/tb/int_value_ff[3]} {-color Coral -height 23 -radix decimal -radixshowbase 0} {/tb/int_value_ff[2]} {-color Coral -height 23 -radix decimal -radixshowbase 0} {/tb/int_value_ff[1]} {-color Coral -height 23 -radix decimal -radixshowbase 0} {/tb/int_value_ff[0]} {-color Coral -height 23 -radix decimal -radixshowbase 0}} /tb/int_value_ff
add wave -noupdate -divider {int2fp conversion}
add wave -noupdate -color Khaki -childformat {{{/tb/i_cvt_int2fp/fp_res[7]} -radix hexadecimal} {{/tb/i_cvt_int2fp/fp_res[6]} -radix hexadecimal} {{/tb/i_cvt_int2fp/fp_res[5]} -radix hexadecimal} {{/tb/i_cvt_int2fp/fp_res[4]} -radix hexadecimal} {{/tb/i_cvt_int2fp/fp_res[3]} -radix hexadecimal} {{/tb/i_cvt_int2fp/fp_res[2]} -radix hexadecimal} {{/tb/i_cvt_int2fp/fp_res[1]} -radix hexadecimal} {{/tb/i_cvt_int2fp/fp_res[0]} -radix hexadecimal}} -expand -subitemconfig {{/tb/i_cvt_int2fp/fp_res[7]} {-color Khaki -height 23 -radix hexadecimal} {/tb/i_cvt_int2fp/fp_res[6]} {-color Khaki -height 23 -radix hexadecimal} {/tb/i_cvt_int2fp/fp_res[5]} {-color Khaki -height 23 -radix hexadecimal} {/tb/i_cvt_int2fp/fp_res[4]} {-color Khaki -height 23 -radix hexadecimal} {/tb/i_cvt_int2fp/fp_res[3]} {-color Khaki -height 23 -radix hexadecimal} {/tb/i_cvt_int2fp/fp_res[2]} {-color Khaki -height 23 -radix hexadecimal} {/tb/i_cvt_int2fp/fp_res[1]} {-color Khaki -height 23 -radix hexadecimal} {/tb/i_cvt_int2fp/fp_res[0]} {-color Khaki -height 23 -radix hexadecimal}} /tb/i_cvt_int2fp/fp_res
add wave -noupdate -divider {fp2int conevrsion}
add wave -noupdate -radix decimal -childformat {{{/tb/i_cvt_cmp_fp2int/int_conv[7]} -radix decimal} {{/tb/i_cvt_cmp_fp2int/int_conv[6]} -radix decimal} {{/tb/i_cvt_cmp_fp2int/int_conv[5]} -radix decimal} {{/tb/i_cvt_cmp_fp2int/int_conv[4]} -radix decimal} {{/tb/i_cvt_cmp_fp2int/int_conv[3]} -radix decimal} {{/tb/i_cvt_cmp_fp2int/int_conv[2]} -radix decimal} {{/tb/i_cvt_cmp_fp2int/int_conv[1]} -radix decimal} {{/tb/i_cvt_cmp_fp2int/int_conv[0]} -radix decimal}} -radixshowbase 0 -expand -subitemconfig {{/tb/i_cvt_cmp_fp2int/int_conv[7]} {-height 23 -radix decimal -radixshowbase 0} {/tb/i_cvt_cmp_fp2int/int_conv[6]} {-height 23 -radix decimal -radixshowbase 0} {/tb/i_cvt_cmp_fp2int/int_conv[5]} {-height 23 -radix decimal -radixshowbase 0} {/tb/i_cvt_cmp_fp2int/int_conv[4]} {-height 23 -radix decimal -radixshowbase 0} {/tb/i_cvt_cmp_fp2int/int_conv[3]} {-height 23 -radix decimal -radixshowbase 0} {/tb/i_cvt_cmp_fp2int/int_conv[2]} {-height 23 -radix decimal -radixshowbase 0} {/tb/i_cvt_cmp_fp2int/int_conv[1]} {-height 23 -radix decimal -radixshowbase 0} {/tb/i_cvt_cmp_fp2int/int_conv[0]} {-height 23 -radix decimal -radixshowbase 0}} /tb/i_cvt_cmp_fp2int/int_conv
add wave -noupdate -divider res
add wave -noupdate -color Magenta -format Literal /tb/i_cvt_cmp_fp2int/cmp_type_i
add wave -noupdate -color Cyan -radix hexadecimal /tb/i_cvt_cmp_fp2int/comp_int_en_o
add wave -noupdate -color Cyan -radix decimal -radixshowbase 0 /tb/i_cvt_cmp_fp2int/comp_int_o
add wave -noupdate -divider <NULL>
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {225000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 149
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {114097 ps} {151665 ps}
