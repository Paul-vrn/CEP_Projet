# TAG = bge
	.text
test1:
	lui x31, 0
	addi x29, x0, 1
	beq x29, x31, test3
test2:
	addi x31, x31, 2
	beq x29, x31, test3
	beq x31, x31, end 
test3:
beq x29, x0, test2
	addi x31, x31, 1
	end:
	addi x31, x31, 1
	# max_cycle 50
	# pout_start
	# 00000000
	# 00000002
	# 00000003
	# pout_end
