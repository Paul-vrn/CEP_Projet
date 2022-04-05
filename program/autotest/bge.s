# TAG = bge
# rs1 ≥ rs2 ⇒ pc ← pc + cst
	.text
test1:
	lui x31, 0
	addi x29, x0, 1
	bge x29, x31, test3
test2:
	addi x31, x31, 2
	bge x29, x31, test3
	bge x31, x31, end 
test3:
	bge x29, x0, test2
	addi x31, x31, 3
end:
	addi x31, x31, 4
	# max_cycle 50
	# pout_start
	# 00000000
	# 00000002
	# 00000006
	# pout_end
