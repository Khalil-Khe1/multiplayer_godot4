extends Turf

func _init():
	init_default()
	land_name = "the fucking irs"
	square = 38
	is_land = false
	font_color = Color(0, 0, 0, 1)
	audio = ""
	set_image("res://resources/squares/irs.png")
	set_buttons([])

func on_enter(player : Player):
	var dm = player.get_resources()["dirty"]
	var cm = player.get_resources()["clean"]
	var df : float = 0.2
	var cf : float = 0.2
	if(dm > 100000):
		df = 0.3
	if(dm > 1000000):
		df = 0.5
	if(cm > 100000):
		cf = 0.3
	if(cm > 1000000):
		cf = 0.5
	player.deplete_resource("dirty", dm * df)
	player.deplete_resource("clean", cm * cf)
