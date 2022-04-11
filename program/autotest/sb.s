# TAG = sb
	.text
	la x1, test
	sb x31, 0(x1)
	# max_cycle 50
	# 000000fe
	# pout_end
	.data
test: .byte 0xfe
