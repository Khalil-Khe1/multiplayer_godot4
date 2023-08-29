extends Card

func _init():
	default_init()
	id = 1
	title = "it aint' personal"
	description = "claim a turf"
	count = 1
	tier = 2

func on_activate():
	var scene : Control = load("res://scenes/card_activate.tscn").instantiate()
	var shares : Shares = get_node("/root/server/gamescene").get_shares()
	var current : Player = get_node("/root/server/gamescene").get_current()
	scene.get_node("Panel/description").set_text("[center]" + description)
	for l in shares.list_all():
		var land : Turf = l
		scene.get_node("Panel/combo").add_item(land.get_title(), land.get_square())
	scene.get_node("Panel/confirm").set_action_mode(0)
	scene.get_node("Panel/confirm").pressed.connect(
		func():
			var selected : int = scene.get_node("Panel/combo").get_selected_id()
			if(selected == -1):
				return
			shares.takeover(current, shares.find(selected))
			scene.get_parent().remove_child(scene)
			scene.queue_free()
			
	)
	scene.get_node("Panel/exit").set_action_mode(0)
	scene.get_node("Panel/exit").pressed.connect(
		func():
			scene.get_parent().remove_child(scene)
			scene.queue_free()
	)
