# int2fp rtl project (FPGA) project fp16 fp32
Parametrizable (single/half precision) converter signed int to fp(32/16);
Parametrizable (single/half precision) converter fp(32/16) to signed integer, that issues smaller or biggest converted value

Brief:
What is it:
This modules could convert integer vector to float point vector and compare fp result.

Parametrization:
This modules are parameterizable, you could chose fp16 or fp32 fp-type, 
could choose quantity words at modules input, could chose comparison type
to get smaller or bigger converted value at output
