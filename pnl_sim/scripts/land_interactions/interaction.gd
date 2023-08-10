extends Node

class_name Interaction

var id : int
var button : Button
var parent_node : Node

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

func set_parent(parent : Node):
	self.parent_node = parent

func get_parent_node():
	return self.parent_node

func set_up(player : Player, land : Turf):
	pass

func free_previous():
	for ch in parent_node.get_children():
		parent_node.remove_child(ch)
		ch.queue_free()
