# TAG = jalr
	.text
	la x1, test
	jalr x31, 0(x1)
	addi x31, x31, 1
end:
	# max_cycle 50
	# pout_start
	# 00001010
	# pout_end
	.data
test: .word 0x00001010
