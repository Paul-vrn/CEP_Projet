# TAG = csrrw
	.text
	addi x28, x0, 5
	csrrw x0, mie, x28
	csrrw x31, mie, x0
	# max_cycle 100
	# pout_start
	# 00000005
	# pout_end
