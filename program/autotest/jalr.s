# TAG = jalr
	.text
	la x1, end
	jalr x31, 0(x1)
	addi x31, x31, 1 # instruction skipped par le jalr
end:
	# max_cycle 50
	# pout_start
	# 0000100c
	# pout_end
	.data
test: .word 0xcafecafe
