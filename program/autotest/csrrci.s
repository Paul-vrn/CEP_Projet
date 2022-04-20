# TAG = csrrci
	.text
	csrrci x0, mie, 5 # csr = "101"
	csrrci x31, mie, 4 # csr = "101" and not("10") = "001" 
	csrrci x31, mie, 0
	# max_cycle 100
	# pout_start
	# 00000005
	# 00000001
	# pout_end
