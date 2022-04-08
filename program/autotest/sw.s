# TAG = sw
	.text
	la x1, test
	addi x31, x0, 0xcafecafe
	sw x31, 0(x1)
	addi x31, x31, 1
	lw x31, 0(x1)
	# max_cycle 50
	# cafecafe
	# cafecaff
	# cafecafe
	# pout_end

	.data
test: .word 0xcafecafe