extends Interaction

var parent_control

func _init():
	id = 16
	self.set_button("Launder")

func set_up(player : Player, land : Turf):
	pass

func on_pressed(player : Player, land : Turf):
	self.button.pressed.connect(
		func ():
			parent_control = get_tree().get_root().get_node("server/control/game_ui/land_panel/misc")
			var new_panel = load("res://scenes/interactions.tscn").new()
			var dialog = "[center]Saul Goodman, attourney at law!\n[center]Launder your money at a 20% rate"
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
					player.append_resource("clean", player.get_resources()["dirty"] * 0.8)
					player.deplete_resource("dirty", value)
					parent_control.remove_child(new_panel)
					new_panel.queue_free()
			)
			var close_btn = Button.new()
			close_btn.set_text("Leave my office")
			close_btn.set_action_mode(0)
			close_btn.pressed.connect(
				func ():
					parent_control.remove_child(new_panel)
					new_panel.queue_free()
			)
			parent_control.add_child(new_panel)
	)
