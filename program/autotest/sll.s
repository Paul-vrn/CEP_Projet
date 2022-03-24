# TAG = sll
	.text
	addi x1, x0, 1
	addi x31, x31, 1
	sll x31, x31, x1
	sll x31, x31, x1
	sll x31, x31, x1
	sll x31, x31, x1
	# max_cycle 50
	# pout_start
	# 00000001
	# 00000002
	# 00000004
	# 00000008
	# 00000010
	# pout_end
