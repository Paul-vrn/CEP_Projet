# TAG = sh
	.text
	la x31, test
	addi x31, x31, 1
	sh x31, test
	la x31, test
	# max_cycle 50
	# pout_start
	# 0000CAFE
	# 0000CAFF
	# 0000CAFF
	# pout_end

	.data
test: .half 0xcafe