# TAG = sltu
	.text
	addi x28, x0, 5
	addi x29, x0, 6
	slt x31, x28, x29
	slt x31, x29, x28
	slt x31, x29, x29
	# max_cycle 50
	# pout_start
	# 00000001
	# 00000000
	# 00000000
	# pout_end
