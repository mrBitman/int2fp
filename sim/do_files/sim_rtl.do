# Modelsim RTL simulation
vlib work
transcript on

# rtl
vlog -work work +define+SIM_RTL +incdir+ ../rtl/*.sv

# testbench
vlog -work work +define+SIM_RTL tb/tb.sv

# launch
vlog -work work -refresh -force_refresh
vsim -t 1ps -voptargs=+acc work.tb

# waves
do ../modelsim_waves/wave_res.do
do ../modelsim_waves/wave_err.do

run 100000ps
wave zoom full