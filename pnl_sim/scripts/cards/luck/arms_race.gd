extends Card

func _init():
	default_init()
	id = 16
	title = "arms race"
	description = "generate (x)*25 arms per turn (avec x nombre de copies de cette carte)"
	count = 4
	tier = 2
	is_passive = true

func on_activate():
	pass

func on_passive():
	for p in get_node("/root/server/gamescene").get_players():
		var copies : int = 0
		for i in p.get_inventory()["cards"]:
			if(i == 16):
				copies = copies + 1
		p.append_resource("arms", 25 * copies)
