# TAG = sh
	.text
	la x1, test
	addi x31, x0, 0xcafe
	sw x31, 0(x1)
	addi x31, x31, 1
	lw x31, 0(x1)
	# max_cycle 50
	# pout_start
	# 0000cafe
	# 0000caff
	# 0000cafe
	# pout_end

	.data
test: .half 0xcafe
