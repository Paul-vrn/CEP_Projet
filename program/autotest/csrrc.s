# TAG = csrrc
	.text
	addi x28, x0, 5 # "101"
	addi x29, x0, 4 # "100"
	csrrc x0, mie, x28 # csr = "101"
	csrrc x31, mie, x29 # csr = "101" and not("10") = "001" 
	csrrc x31, mie, x0
	# max_cycle 50
	# pout_start
	# 00000005
	# 00000001
	# pout_end
