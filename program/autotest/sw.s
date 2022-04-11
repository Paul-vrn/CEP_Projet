# TAG = sw
	.text
	la x31, test
	# max_cycle 50
	# 0000000c
	# 0000000d
	# 0000000c
	# pout_end

	.data
test: .word 0xcafecafe
