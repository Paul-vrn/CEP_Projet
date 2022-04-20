# TAG = csrrci
	.text
	csrrc x0, mie, 5 # csr = "101"
	csrrc x31, mie, 4 # csr = "101" and not("10") = "001" 
	csrrc x31, mie, 0
	# max_cycle 50
	# pout_start
	# 00000005
	# 00000001
	# pout_end
