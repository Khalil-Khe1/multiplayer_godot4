extends Turf

var copies : int = 0

func _init():
	init_default()
	land_name = "goons 2"
	square = 15
	resources = {"arms" : [0, 25]}
	price = 0
	font_color = Color(0, 0, 0, 1)

func on_acquire():
	var gc : GameController = get_node("/root/Server/gamescene")
	var current : Player = self.land_owner
	for id in current.get_inventory()["cards"]:
		if((id == 5)||(id == 15)||(id == 25)||(id == 35)):
			copies = copies + 1
	resources["arms"][1] = 25 * copies

func on_dismiss():
	copies = copies - 1
	resources["arms"][1] = 25 * copies
