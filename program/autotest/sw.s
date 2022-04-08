# TAG = sw
	.text
	la x31, test
	addi x31, x31, 1
	sh x31, test
	la x31, test
	# max_cycle 50
	# pout_start
	# cafecafe
	# cafecaff
	# cafecaff
	# pout_end

	.data
test: .word 0xcafecafe