extends Interaction

var prices : Dictionary

func _init():
	id = 8
	self.set_button("Buy coke")

func activate():
	pass

func set_up(player : Player, land : Turf):
	parent_node = parent_node.get_parent().get_node("interaction_panel")
	on_pressed(player, land)

func on_pressed(player : Player, land : Turf):
	self.button.pressed.connect(
		func ():
			free_previous()
			var new_panel = load("res://scenes/interactions.tscn").instantiate()
			var dialog = "\n[center]Buy coke"
			new_panel.get_node("dialog").set_text(dialog)
			var interact_btn = Button.new()
			interact_btn.set_text("Buy")
			interact_btn.set_action_mode(0)
			interact_btn.pressed.connect(
				func ():
					var value = new_panel.get_node("edit").get_text()
					if(!value.is_valid_int()):
						return
					value = int(value)
					if(player.get_resources()["dirty"] < value * land.get_inventory()["coke"][1]):
						return
					player.append_resource("coke", value)
					player.deplete_resource("dirty", value * land.get_inventory()["coke"][1])
					parent_node.remove_child(new_panel)
					new_panel.queue_free()
			)
			var close_btn = Button.new()
			close_btn.set_text("Piss off")
			close_btn.set_action_mode(0)
			close_btn.pressed.connect(
				func ():
					parent_node.remove_child(new_panel)
					new_panel.queue_free()
			)
			new_panel.get_node("hbox").set_alignment(HORIZONTAL_ALIGNMENT_CENTER)
			new_panel.get_node("hbox").add_child(interact_btn)
			new_panel.get_node("hbox").add_child(close_btn)
			parent_node.add_child(new_panel)
	)
