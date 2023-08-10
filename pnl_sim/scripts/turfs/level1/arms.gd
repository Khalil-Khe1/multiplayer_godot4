extends Turf

func _init():
	init_default()
	land_name = "arms dealer"
	square = 20
	is_land = false
	font_color = Color(0, 0, 0, 1)
	audio = ""
	set_image("res://resources/squares/dealer.png")
	set_buttons([4, 5])
	inventory = { #item : [buy, sell]
		"firearms" : [700, 1000]
	}
