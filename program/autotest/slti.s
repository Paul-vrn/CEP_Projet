# TAG = slti
	.text
	addi x28, x0, 5
	addi x29, x0, 6
	slti x31, x28, 6
	slti x31, x29, 5
	slti x31, x29, 6
	# max_cycle 50
	# pout_start
	# 00000001
	# 00000000
	# 00000000
	# pout_end
