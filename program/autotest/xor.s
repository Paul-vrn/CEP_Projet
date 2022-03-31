# TAG = xor
	.text
	addi x29, x0, 1 
	addi x30, x0, 0
	xor x31, x29, x29 # 1 xor 1
	xor x31, x30, x29 # 0 xor 1
	xor x31, x29, x30 # 1 xor 0
	xor x31, x30, x30 # 0 xor 0
	# max_cycle 50
	# pout_start
	# 00000000
	# 00000001
	# 00000001
	# 00000000
	# pout_end
