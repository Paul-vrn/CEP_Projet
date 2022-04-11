# TAG = sb
	.text
	lui x31, 0	
	la x1, test
	lb x31, 0(x1)
	addi x2, x31, 1
	sb x2, 0(x1)
	lb x31, 0(x1)
	addi x2, x31, -1
	sb x2, 0(x1)
	# max_cycle 5
	# pout_start
	# 00000000
	# fffffffe
	# ffffffff
	# pout_end
	.data
test: .byte 0xfe
