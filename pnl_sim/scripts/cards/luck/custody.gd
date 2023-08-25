extends Card

func _init():
	default_init()
	id = 1
	title = "Police Custody"
	description = "Stun a person for one turn"
	count = 4
	tier = 1

func on_activate():
	var scene : Control = load("res://scenes/card_activate.tscn").instantiate()
	var players : Array = get_node("/root/server/gamescene").controller.get_players() #TEST THIS
	scene.get_node("Panel/description").set_text("[center]" + description)
	for p in players:
		if(p.get_id() == get_node("/root/server/gamescene").get_current().get_id()):
			continue
		scene.get_node("Panel/combo").add_item(p.get_player_name(), p.get_id())
	scene.get_node("Panel/confirm").set_action_mode(0)
	scene.get_node("Panel/confirm").pressed.connect(
		func():
			var selected : int = scene.get_node("Panel/combo").get_selected_id()
			if(selected == -1):
				return
			for p in players:
				if(p.get_id() == selected):
					p.set_is_stunned(true)
					break
			scene.get_parent().remove_child(scene)
			scene.queue_free()
	)
	scene.get_node("Panel/exit").set_action_mode(0)
	scene.get_node("Panel/exit").pressed.connect(
		func():
			scene.get_parent().remove_child(scene)
			scene.queue_free()
	)
