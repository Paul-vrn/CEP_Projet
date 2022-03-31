# TAG = andi
	.text
	addi x29, x0, 1 
	addi x30, x0, 0
	andi x31, x29, 0x00000001 # 1 andi 1
	andi x31, x29, 0 # 1 andi 0
	andi x31, x30, 0 # 0 andi 0
	# max_cycle 50
	# pout_start
	# 00000001
	# 00000000
	# 00000000
	# pout_end
