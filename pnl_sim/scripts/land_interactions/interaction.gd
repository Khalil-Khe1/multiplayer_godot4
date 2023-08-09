extends Node

class_name Interaction

var id : int
var button : Button

func _init():
	id = -1

func get_id():
	return self.id

func get_button():
	return self.button

func set_button(name : String):
	button = Button.new()
	button.set_text(name)
	button.set_action_mode(0)

func set_up(player : Player, land : Turf):
	pass
