extends Card

func _init():
	default_init()
	id = 1
	title = "distribution genius"
	description = "instantly deplete your stock for as many ients-clit as you have in your network"
	count = 1
	tier = 3

func on_activate():
	var current : Player = get_node("/root/server/gamescene").get_current()
	current.deplete_stock()
