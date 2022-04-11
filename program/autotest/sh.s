# TAG = sh
	.text	
	lui x31, 0	
	la x1, test
	lh x31, 0(x1)
	addi x2, x31, 1
	sh x2, 0(x1)
	lh x31, 0(x1)
	addi x2, x31, -1
	sh x2, 0(x1)
	# max_cycle 50
	# pout_start
	# 00000000
	# ffffcafe
	# ffffcaff
	# pout_end
	.data
test: .half 0xcafe
