# TAG = srl
	.text
	addi x1, x0, 4
	addi x31, x0, 0xffffffff
	srl x31, x31, x1
	srl x31, x31, x1
	srl x31, x31, x1
	srl x31, x31, x1
	# max_cycle 50
	# pout_start
	# ffffffff
	# 0fffffff
	# 00ffffff
	# 000fffff
	# 0000ffff
	# pout_end
