# TAG = csrrwi
	.text
	csrrwi x0, mie, 5
	csrrwi x31, mie, 0
	# max_cycle 100
	# pout_start
	# 00000005
	# pout_end
