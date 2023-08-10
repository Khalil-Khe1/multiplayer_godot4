extends Interaction

func _init():
	id = 1
	self.set_button("Contest")

func activate():
	pass

func set_up(player : Player, land : Turf):
	var fa = player.get_resources()["firearms"]
	var land_fa = land.get_firearms()
	if(fa < land_fa):
		self.button.set_disabled(true)
	parent_node = parent_node.get_parent().get_node("interaction_panel")
	on_pressed(player, land)

func on_pressed(player : Player, land : Turf):
	self.button.pressed.connect(
		func ():
			free_previous()
			player.deplete_resource("firearms", land.get_firearms() + 1)
			land.set_firearms(0)
			var shares : Shares = Shares.new()
			shares.takeover(player, land)
	)
