# TAG = and
	.text
	addi x29, x0, 1 
	addi x30, x0, 0
	and x31, x29, x29 # 1 and 1
	and x31, x30, x29 # 0 and 1
	and x31, x29, x30 # 1 and 0
	and x31, x30, x30 # 0 and 0
	# max_cycle 50
	# pout_start
	# 00000001
	# 00000000
	# 00000000
	# 00000000
	# pout_end
