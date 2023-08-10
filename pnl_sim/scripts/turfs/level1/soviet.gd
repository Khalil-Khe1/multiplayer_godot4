extends Turf

func _init():
	init_default()
	land_name = "soviet connection"
	square = 17
	is_land = false
	font_color = Color(0, 0, 0, 1)
	audio = "res://resources/squares/videos/soviet_drill.mp3"
	play_at = 20
	set_image("res://resources/squares/soviet_connection.png")
	set_buttons([4, 5, 6, 7])
	inventory = { #item : [buy, sell]
		"firearms" : [1400, 1800],
		"weed" : [3500, 4200]
	}
