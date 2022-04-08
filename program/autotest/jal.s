# TAG = jal
	.text
	jal x31, test
	addi x31, x0, 12
test:
	addi x31, x0, 1
	# max_cycle 50
	# pout_start
	# 00001004
	# 00000001
	# pout_end
