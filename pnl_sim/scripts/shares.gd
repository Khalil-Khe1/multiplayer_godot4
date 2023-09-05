extends Node

class_name Shares #controller for lands/turfs

var lands : Array

func _init(): #init function which is resetting the gameplay objects to default state
	var path = "res://scripts/turfs/level1"
	var dir = DirAccess.open(path)
	for f in dir.get_files():
		var land_instance = load(path + "/" + f).new()
		lands.append(post_instantiate(land_instance))

func post_instantiate(land : Turf) -> Turf:
	if(land.get_is_land()):
		land.set_firearms(land.get_square() * 2)
		land.set_price(land.get_square() * 25000)
		land.generate_description()
	return land

func find(square : int):
	for l in lands:
		if(l.get_square() == square):
			return l

func find_name(name : String):
	for l in lands:
		if(l.get_land_name() == name):
			return l

func assign_share(player : Player, share : float, land : Turf):
	var previous_share : float = 0
	for o in land.get_owners().keys():
		if(o == player):
			previous_share = land.get_owners()[o]
			break
	if(previous_share == 0):
		player.append_inventory("lands", land.get_square())
	land.get_owners()[player] = share
	update_resources(player, land, share, previous_share)
	check_for_ownership(player, share, land)
	if(share == 0):
		land.on_dismiss()
		land.get_owners().erase(player)
		player.erase_inventory("lands", land.get_square())
		return
		land.on_acquire()

func check_for_ownership(player : Player, share : float, land : Turf):
	if(share >= 0.51):
		land.set_land_owner(player)

func trade_share(seller : Player, buyer : Player, share : float, land : Turf): #TEST THIS
	assign_share(seller, land.get_owners()[seller] - share, land) 
	print(land.get_owners()[buyer])
	print(buyer in land.get_owners().keys())
	if(buyer != null):
		assign_share(buyer, land.get_owners()[buyer] + share, land) 

func update_resources(player: Player, land : Turf, share : float, previous_share : float):
	for r in land.get_resources().keys():
		var res = player.get_resources()[r] - land.get_resources()[r][0] * (share - previous_share)
		player.set_resource(r, res)

func takeover(player : Player, land : Turf):
	land.set_firearms(0)
	for k in land.get_resources().keys():
		for o in land.get_owners().keys():
			#o.deplete_resource(k, land.get_resources()[k][0] * land.get_owners()[o])
			assign_share(o, 0, land)
		#player.append_resource(k, land.get_resources()[k][0])
	assign_share(player, 1, land)

func raid(land : Turf):
	for k in land.get_resources().keys():
		for o in land.get_owners().keys():
			#o.deplete_resource(k, land.get_resources()[k][0] * land.get_owners()[o])
			assign_share(o, 0, land)

func purchase(land : Turf, player : Player):
	takeover(player, land)
	land.set_is_purchased(true)

func list_all() -> Array:
	var callable : Callable = Callable(self, "custom_sort")
	var res = lands
	res.sort_custom(callable)
	return res

func list_by_owner(owner : Player) -> Dictionary:
	var res : Dictionary = {}
	for l in lands:
		var shares = l.get_owners()
		if(owner in shares.keys()):
			res[l] = shares[owner]
	return res

func custom_sort(a : Turf, b : Turf):
	return a.get_square() < b.get_square()
