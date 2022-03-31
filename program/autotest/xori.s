# TAG = xori
	.text
	addi x29, x0, 1 
	addi x30, x0, 0
	xori x31, x29, 0x00000001 # 1 xor 1
	xori x31, x30, 0x00000001 # 0 xor 1
	xori x31, x30, 0 # 0 xor 0
	# max_cycle 50
	# pout_start
	# 00000000
	# 00000001
	# 00000000
	# pout_end
