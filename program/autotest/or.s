# TAG = or
	.text
	addi x29, x0, 1 
	addi x30, x0, 0
	or x31, x29, x29 # 1 or 1
	or x31, x30, x29 # 0 or 1
	or x31, x29, x30 # 1 or 0
	or x31, x30, x30 # 0 or 0
	# max_cycle 50
	# pout_start
	# 00000001
	# 00000001
	# 00000001
	# 00000000
	# pout_end
