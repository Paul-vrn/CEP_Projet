# TAG = lhu
	.text
	la x28, test
	lh x31, 0(x28)
	# max_cycle 50
	# pout_start
	# 0000ffff
	# pout_end
	.data
test: .half 0xffff
