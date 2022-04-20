# TAG = csrrsi
	.text
	csrrsi x0, mie, 5 # csr = "101"
	csrrsi x31, mie, 2 # csr = "101" || "10" = "111" 
	csrrsi x31, mie, 0
	# max_cycle 100
	# pout_start
	# 00000005
	# 00000007
	# pout_end
