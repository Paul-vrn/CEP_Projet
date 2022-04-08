# TAG = sb
	.text
	la x1, test
	addi x31, x0, 0xfe
	sw x31, 0(x1)
	addi x31, x31, 1
	lw x31, 0(x1)
	# max_cycle 50
	# pout_start
	# 000000fe
	# 000000ff
	# 000000fe
	# pout_end

	.data
test: .byte 0xfe