# TAG = beq
	.text
test1:
	lui x31, 0
	lui x29, 0
	beq x31, x29, test3
test2:
	lui x28, 1
	lui x29, 2
	addi x31, x31, 1
	beq x28, x29, test1
	beq x0, x0, end 
test3:
beq x0, x0, test2
	addi x31, x31, 1
	end:
	addi x31, x31, 1
	# max_cycle 50
	# pout_start
	# 00000000
	# 00000001
	# 00000002
	# pout_end
