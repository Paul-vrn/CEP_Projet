# TAG = csrrwi
	.text
	csrrw x0, mie, 5
	csrrw x31, mie, 0
	# max_cycle 50
	# pout_start
	# 00000005
	# pout_end
