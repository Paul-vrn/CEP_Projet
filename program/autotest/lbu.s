# TAG = lbu
	.text
	la x28, test
	lb x31, 0(x28)
	# max_cycle 50
	# pout_start
	# 000000fe
	# pout_end
	.data
test: .byte 0xfe
