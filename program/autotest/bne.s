# TAG = bne
	.text
test1:
	lui x31, 0
	addi x29, x0, 1
	bne x31, x29, test3
test2:
	
	addi x31, x31, 1
	bne x31, x29, test3
	bne x0, x31, end 
test3:
	bne x0, x0, test2
	addi x31, x31, 1
	end:
	addi x31, x31, 1
	# max_cycle 50
	# pout_start
	# 00000000
	# 00000001
	# 00000002
	# pout_end
