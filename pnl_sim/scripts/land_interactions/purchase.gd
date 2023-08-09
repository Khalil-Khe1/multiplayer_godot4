extends Interaction

func _init():
	id = 2
	self.set_button("Purchase")

func set_up(player : Player, land : Turf):
	var cm = player.get_resources()["clean"]
	var land_cm = land.get_price()
	if(cm < land_cm):
		self.button.set_disabled(false)
	on_pressed(player, land)

func on_pressed(player : Player, land : Turf):
	self.button.pressed.connect(
		func ():
			player.deplete_resource("clean", land.get_price())
			var shares : Shares = Shares.new()
			shares.takeover(player, land)
			land.set_is_purchased(true)
	)
