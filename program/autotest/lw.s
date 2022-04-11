# TAG = lw
	.text
	la x28, test
	lw x31, 0(x28)
	# max_cycle 50
	# pout_start
	# cafecafe
	# pout_end
test: .word 0xcafecafe
