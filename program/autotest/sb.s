# TAG = sb
	.text
	la x31, test
	addi x31, x31, 1
	sh x31, test
	la x31, test
	# max_cycle 50
	# pout_start
	# 000000ef
	# 000000f0
	# 000000f0
	# pout_end

	.data
test: .byte 0xef