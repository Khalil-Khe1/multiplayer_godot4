extends Card

var copies : int = 0

func _init():
	default_init()
	id = 1
	title = "arms race"
	description = "generate (x)*25 arms per turn (avec x nombre de copies de cette carte)"
	count = 4
	tier = 2

func on_activate():
	var current : Player = get_node("/root/server/gamescene").get_current()
	for i in current.get_inventory()["cards"]:
		if(i == 16):
			copies = copies + 1
	var callable : Callable = Callable(self, "generate_arms")
	callable.bind(player)
	player.append_start_callables(callable)

func generate_arms(player : Player):
	player.append_resource("arms", 25 * copies)
