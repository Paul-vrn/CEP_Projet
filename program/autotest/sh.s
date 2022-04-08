# TAG = sh
	.text
	la x1, test
	addi x31, x0, 12
	sh x31, 0(x1)
	addi x31, x31, 1
	lw x31, 0(x1)
	# max_cycle 50
	# 0000000c
	# 0000000d
	# 0000000c
	# pout_end
	.data
test: .half 0xcafe

