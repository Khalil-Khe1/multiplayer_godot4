extends Turf

func _init():
	init_default()
	land_name = "sa3oud"
	square = 4
	is_land = false
	font_color = Color(0, 0, 0, 1)
	audio = ""
	set_image("res://resources/squares/sa3oud.png")
	set_buttons([])

func on_pass(player : Player, panel : Panel):
	var aux : Panel = panel
	panel.get_node("exit").set_visible(false)
	var exit_btn = Button.new()
	exit_btn.position = panel.get_node("exit").position
	exit_btn.size = panel.get_node("exit").size
	exit_btn.set_text("X")
	panel.add_child(exit_btn)
	panel.set_visible(true)
	panel.get_node("square/land_title").set_text("[center]" + self.get_land_name())
	panel.get_node("square/land_title").add_theme_color_override("default_color", self.get_font_color_raw())
	panel.get_node("square/color").get_theme_stylebox("panel").bg_color = self.get_color_raw()
	panel.get_node("Sprite2D").set_texture(self.get_image().get_texture())
	panel.get_node("misc/description_panel/description").set_text(self.get_description())
	var new_panel = load("res://scenes/interactions.tscn").instantiate()
	new_panel.get_node("dialog").set_visible(false)
	new_panel.get_node("hbox").set_visible(false)
	new_panel.get_node("edit").set_visible(false)
	new_panel.get_node("scroll").set_visible(true)
	var vbox = new_panel.get_node("scroll/vbox")
	await exit_btn.pressed
	panel = aux
