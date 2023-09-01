extends Card

var capital : int = 0

func _init():
	default_init()
	id = 14
	title = "the botanist"
	description = "fund your weed farms to generate le shit per turn (minimum $$5000)"
	count = 1
	tier = 3
	is_passive = true

func on_activate():
	var scene : Control = load("res://scenes/card_activate.tscn").instantiate()
	var current : Player = get_node("/root/server/gamescene").get_current()
	scene.get_node("Panel/combo").set_visible(false)
	scene.get_node("Panel/input").set_visible(true)
	var amount : int = int(scene.get_node("Panel/input").get_text())
	scene.get_node("Panel/description").set_text("[center]" + description)
	scene.get_node("Panel/confirm").set_action_mode(0)
	scene.get_node("Panel/confirm").pressed.connect(
		func():
			if(amount < 5000):
				return
			if(!player.pay_dirty(amount)):
				return
			capital = capital + amount
			scene.get_parent().remove_child(scene)
			scene.queue_free()
			
	)
	scene.get_node("Panel/exit").set_action_mode(0)
	scene.get_node("Panel/exit").pressed.connect(
		func():
			scene.get_parent().remove_child(scene)
			scene.queue_free()
	)

func on_passive():
	var players : Array= get_node("/root/server/gamescene").get_players()
	for p in players:
		for i in p.get_inventory()["cards"]:
			if(i == 14):
				p.append_resource("weed", int(capital / 500))
