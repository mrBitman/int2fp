onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /modules_params_pkg::WORD_LEN
add wave -noupdate -radix decimal -radixshowbase 1 /tb/NUM_WORDS
add wave -noupdate -divider {input int}
add wave -noupdate -color Coral -radix decimal -childformat {{{/tb/int_value_ff[7]} -radix decimal} {{/tb/int_value_ff[6]} -radix decimal} {{/tb/int_value_ff[5]} -radix decimal} {{/tb/int_value_ff[4]} -radix decimal} {{/tb/int_value_ff[3]} -radix decimal} {{/tb/int_value_ff[2]} -radix decimal} {{/tb/int_value_ff[1]} -radix decimal} {{/tb/int_value_ff[0]} -radix decimal}} -radixshowbase 0 -expand -subitemconfig {{/tb/int_value_ff[7]} {-color Coral -height 23 -radix decimal -radixshowbase 0} {/tb/int_value_ff[6]} {-color Coral -height 23 -radix decimal -radixshowbase 0} {/tb/int_value_ff[5]} {-color Coral -height 23 -radix decimal -radixshowbase 0} {/tb/int_value_ff[4]} {-color Coral -height 23 -radix decimal -radixshowbase 0} {/tb/int_value_ff[3]} {-color Coral -height 23 -radix decimal -radixshowbase 0} {/tb/int_value_ff[2]} {-color Coral -height 23 -radix decimal -radixshowbase 0} {/tb/int_value_ff[1]} {-color Coral -height 23 -radix decimal -radixshowbase 0} {/tb/int_value_ff[0]} {-color Coral -height 23 -radix decimal -radixshowbase 0}} /tb/int_value_ff
add wave -noupdate -divider {fp2int conevrsion}
add wave -noupdate -radix decimal -childformat {{{/tb/i_cvt_cmp_fp2int/int_conv[7]} -radix decimal} {{/tb/i_cvt_cmp_fp2int/int_conv[6]} -radix decimal} {{/tb/i_cvt_cmp_fp2int/int_conv[5]} -radix decimal} {{/tb/i_cvt_cmp_fp2int/int_conv[4]} -radix decimal} {{/tb/i_cvt_cmp_fp2int/int_conv[3]} -radix decimal} {{/tb/i_cvt_cmp_fp2int/int_conv[2]} -radix decimal} {{/tb/i_cvt_cmp_fp2int/int_conv[1]} -radix decimal} {{/tb/i_cvt_cmp_fp2int/int_conv[0]} -radix decimal}} -radixshowbase 0 -expand -subitemconfig {{/tb/i_cvt_cmp_fp2int/int_conv[7]} {-height 23 -radix decimal -radixshowbase 0} {/tb/i_cvt_cmp_fp2int/int_conv[6]} {-height 23 -radix decimal -radixshowbase 0} {/tb/i_cvt_cmp_fp2int/int_conv[5]} {-height 23 -radix decimal -radixshowbase 0} {/tb/i_cvt_cmp_fp2int/int_conv[4]} {-height 23 -radix decimal -radixshowbase 0} {/tb/i_cvt_cmp_fp2int/int_conv[3]} {-height 23 -radix decimal -radixshowbase 0} {/tb/i_cvt_cmp_fp2int/int_conv[2]} {-height 23 -radix decimal -radixshowbase 0} {/tb/i_cvt_cmp_fp2int/int_conv[1]} {-height 23 -radix decimal -radixshowbase 0} {/tb/i_cvt_cmp_fp2int/int_conv[0]} {-height 23 -radix decimal -radixshowbase 0}} /tb/i_cvt_cmp_fp2int/int_conv
add wave -noupdate -divider {error to conversion}
add wave -noupdate -color Thistle -radix decimal -childformat {{{/tb/err2conv[7]} -radix decimal} {{/tb/err2conv[6]} -radix decimal} {{/tb/err2conv[5]} -radix decimal} {{/tb/err2conv[4]} -radix decimal} {{/tb/err2conv[3]} -radix decimal} {{/tb/err2conv[2]} -radix decimal} {{/tb/err2conv[1]} -radix decimal} {{/tb/err2conv[0]} -radix decimal}} -radixshowbase 0 -expand -subitemconfig {{/tb/err2conv[7]} {-color Thistle -height 23 -radix decimal -radixshowbase 0} {/tb/err2conv[6]} {-color Thistle -height 23 -radix decimal -radixshowbase 0} {/tb/err2conv[5]} {-color Thistle -height 23 -radix decimal -radixshowbase 0} {/tb/err2conv[4]} {-color Thistle -height 23 -radix decimal -radixshowbase 0} {/tb/err2conv[3]} {-color Thistle -height 23 -radix decimal -radixshowbase 0} {/tb/err2conv[2]} {-color Thistle -height 23 -radix decimal -radixshowbase 0} {/tb/err2conv[1]} {-color Thistle -height 23 -radix decimal -radixshowbase 0} {/tb/err2conv[0]} {-color Thistle -height 23 -radix decimal -radixshowbase 0}} /tb/err2conv
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {86016 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 170
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
WaveRestoreZoom {23745 ps} {74814 ps}
