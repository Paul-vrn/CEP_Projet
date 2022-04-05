# TAG = sra
	.text
	addi x30, x0, 4
	addi x31, x0, 0xffffffff
	sra x31, x31, x30
	sra x31, x31, x30
	sra x31, x31, x30
	sra x31, x31, x30
	# max_cycle 50
	# pout_start
	# ffffffff
	# ffffffff
	# ffffffff
	# ffffffff
	# ffffffff
	# pout_end
