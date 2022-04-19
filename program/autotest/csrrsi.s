# TAG = csrrsi
	.text
	addi x28, x0, 5 # "101"
	addi x29, x0, 2 # "10"
	csrrs x0, mie, 5 # csr = "101"
	csrrs x31, mie, 2 # csr = "101" || "10" = "111" 
	csrrs x31, mie, 0
	# max_cycle 50
	# pout_start
	# 00000005
	# 00000007
	# pout_end
