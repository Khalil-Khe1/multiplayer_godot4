extends Node

class_name Shares #controller for lands/turfs

var lands : Array

func _init():
	var path = "res://scripts/turfs/level1"
	var dir = DirAccess.open(path)
	for f in dir.get_files():
		var land_instance = load(path + "/" + f).new()
		lands.append(land_instance)
	#print(lands)

func find(square : int):
	for l in lands:
		if(l.get_square() == square):
			return l

func find_name(name : String):
	for l in lands:
		if(l.get_land_name() == name):
			return l

func assign_share(player : Player, share : float, land : Turf):
	land.get_owners()[player] = share
	check_for_ownership(player, share, land)

func check_for_ownership(player : Player, share : float, land : Turf):
	if(share >= 0.51):
		land.set_land_owner(player)

func trade_share(seller : Player, buyer : Player, share : float, land : Turf): #TEST THIS
	var shares = land.get_owners()
	shares[seller] = shares[seller] - share
	shares[buyer] = shares[buyer] + share #check if shares[buyer] = 0 if there is no value
	#check assigning the shares to a variable registers the update on the land's shares array

func remove_share(player : Player, land : Turf): #TEST THIS
	for r in land.get_resources():
		player.deplete_resource(r, land.get_resources()[r] * land.get_owners()[player])
	land.get_owners().erase(player)

func list_all() -> Array:
	return lands

func list_by_owner(owner : Player) -> Dictionary:
	var res : Dictionary = {}
	for l in lands:
		var shares = l.get_owners()
		if(owner in shares.keys()):
			res[l] = shares[owner]
	return res
