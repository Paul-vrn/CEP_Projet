# TAG = sw
	.text
	lui x31, 0	
	la x1, test
	lw x31, 0(x1)
	addi x2, x31, 1
	sw x2, 0(x1)
	lw x31, 0(x1)
	addi x2, x31, -1
	sw x2, 0(x1)
	# max_cycle 50
	# pout_start
	# 00000000
	# cafecafe
	# cafecaff
	# pout_end
	.data
test: .word 0xcafecafe
