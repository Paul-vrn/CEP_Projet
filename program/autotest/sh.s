# TAG = sh
	.text
	la x1, test
	sh x31, 0(x1)
	# max_cycle 50
	# 0000cafe
	# pout_end
	.data
test: .half 0xcafe

