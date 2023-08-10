extends Turf

func _init():
	init_default()
	land_name = "the columbian"
	square = 22
	is_land = false
	font_color = Color(0, 0, 0, 1)
	audio = ""
	set_image("res://resources/squares/columbian.png")
	set_buttons([4, 5])
	inventory = { #item : [buy, sell]
		"yayo" : [18000, 24000]
	}
