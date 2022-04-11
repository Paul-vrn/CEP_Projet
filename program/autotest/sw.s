# TAG = sw
	.text
	la x1, test
	sw x31, 0(x1)
	# max_cycle 50
	# cafecafe
	# pout_end

	.data
test: .word 0xcafecafe
