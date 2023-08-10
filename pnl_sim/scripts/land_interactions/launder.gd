extends Interaction

func _init():
	id = 16
	self.set_button("Launder")

func set_up(player : Player, land : Turf):
	parent_node = parent_node.get_parent().get_node("interaction_panel")
	on_pressed(player, land)

func on_pressed(player : Player, land : Turf):
	self.button.pressed.connect(
		func ():
			free_previous()
			var new_panel = load("res://scenes/interactions.tscn").instantiate()
			var dialog = "\n[center]Saul Goodman, attourney at law!\n[center]Launder your money at a 20% rate"
			new_panel.get_node("dialog").set_text(dialog)
			var launder_btn = Button.new()
			launder_btn.set_text("Launder now!")
			launder_btn.set_action_mode(0)
			launder_btn.pressed.connect(
				func ():
					var value = new_panel.get_node("edit").get_text()
					if(!value.is_valid_int()):
						return
					value = int(value)
					if(player.get_resources()["dirty"] < value):
						return
					player.append_resource("clean", value * 0.8)
					player.deplete_resource("dirty", value)
					parent_node.remove_child(new_panel)
					new_panel.queue_free()
			)
			var close_btn = Button.new()
			close_btn.set_text("Leave my office")
			close_btn.set_action_mode(0)
			close_btn.pressed.connect(
				func ():
					parent_node.remove_child(new_panel)
					new_panel.queue_free()
			)
			new_panel.get_node("hbox").set_alignment(HORIZONTAL_ALIGNMENT_CENTER)
			new_panel.get_node("hbox").add_child(launder_btn)
			new_panel.get_node("hbox").add_child(close_btn)
			parent_node.add_child(new_panel)
	)
