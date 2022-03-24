# TAG = addi
	.text
	addi x31, x0, 1 
	addi x31, x31, 0xfffffffe
	addi x31, x31, 1
	# max_cycle 50
	# pout_start
	# 00000001
	# ffffffff
	# 00000000
	# pout_end
