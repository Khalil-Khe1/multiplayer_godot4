extends Interaction

func _init():
	id = 2
	self.set_button("Purchase")

func set_up(player : Player, land : Turf):
	var cm = player.get_resources()["clean"]
	var land_cm = land.get_price()
	if(cm < land_cm):
		self.button.set_disabled(false)
	parent_node = parent_node.get_parent().get_node("interaction_panel")
	on_pressed(player, land)

func on_pressed(player : Player, land : Turf):
	self.button.pressed.connect(
		func ():
			free_previous()
			player.deplete_resource("clean", land.get_price())
			var shares : Shares = Shares.new()
			shares.takeover(player, land)
			land.set_is_purchased(true)
	)
