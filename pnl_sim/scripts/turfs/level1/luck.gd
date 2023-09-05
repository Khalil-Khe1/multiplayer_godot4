extends Turf

func _init():
	init_default()
	land_name = "luck?"
	square = 7
	is_land = false
	font_color = Color(0, 0, 0, 1)

func on_enter():
	var gc : GameController = get_node("/root/Server/gamescene")
	var card_repo : CardRepo = gc.get_cards()
	var current : Player = gc.get_current()
	var card : Card = card_repo.draw_luck()
	current.append_inventory("cards", card.get_id())
