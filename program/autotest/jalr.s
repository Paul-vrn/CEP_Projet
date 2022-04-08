# TAG = jalr
	.text
	lui x6, 0
	jalr x31, 12(x6) # adresse de x6 + 12 -> dernier addi
	addi x31, x0, 12
	addi x31, x0, 1
	# max_cycle 50
	# pout_start
	# 00001008
	# 00000001
	# pout_end
