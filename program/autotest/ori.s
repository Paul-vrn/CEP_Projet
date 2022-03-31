# TAG = ori
	.text
	addi x29, x0, 1 
	addi x30, x0, 0
	ori x31, x29, 0x00000001 # 1 or 1
	ori x31, x29, 0 # 1 or 0
	ori x31, x30, 0 # 0 or 0
	# max_cycle 50
	# pout_start
	# 00000001
	# 00000001
	# 00000000
	# pout_end
