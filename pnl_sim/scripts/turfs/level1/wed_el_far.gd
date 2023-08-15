extends Turf

func _init():
	init_default()
	land_name = "wed el far"
	square = 2
	resources = {"ients-clit" : [0, 0]}
	price = -1
#	land_owner = null
#	shares = {}

func prepare(): #no need for freeze with new implementation
#	for l in land_owner.get_turfs():
#		l.freeze(1)
	pass

func generate():
#	for l in land_owner.get_turfs(): #this line still sussy
#		var res = l.resources["ients-clit"][1]
#		l.resources["ients-clit"][0] = l.resources["ients-clit"][0] - res
#		self.resources["ients-clit"][0] = self.resources["ients-clit"][0] + res
	print("wed el far")
	
