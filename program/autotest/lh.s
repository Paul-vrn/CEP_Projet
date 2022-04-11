# TAG = lh
	.text
	la x28, test
	lh x31, 0(x28)
	# max_cycle 50
	# pout_start
	# ffffffff
	# pout_end
	.data
test: .half 0xffff
