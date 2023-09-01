extends Card

class_name LeM

var is_active : bool

func _init():
	default_init()
	id = 17
	title = "Le M"
	description = "scam your next deal"
	count = 1
	tier = 3
	is_active = false

func on_activate():
	is_active = true

func set_active(a : bool):
	self.is_active = a

func get_active():
	return self.is_active
