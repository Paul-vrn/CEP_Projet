# TAG = addi
	.text

	lui x30, 0		  #Chargement d'une valeur nulle dans x31
	addi x31, x30, 0       #$x31 + 0 = 0 
	addi x31, x30, 1 #retourne à 0
	addi x31, x31, 0xffe
	# max_cycle 50
	# pout_start
	# 00000000
	# 00000001
	# 00000fff
	# pout_end
