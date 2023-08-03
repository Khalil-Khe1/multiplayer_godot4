extends Node

class_name Turf

#general
var land_name : String = "Turf"
var description : String
var color : Color
var image : Sprite2D
var video : VideoStream
var buttons : Array

#stats
var square : int
var price : float
var resources : Dictionary

#shares system
var land_owner : Player
var shares : Dictionary

#per turn status
var can_generate : bool = true
var frozen_turns : int

func _init():
	square = -1
	resources = {}
	price = 0
	frozen_turns = 0
	image = null
	video.set_file("")
	generate_description()
	buttons = []

#Setget
func get_square():
	return self.square

func get_land_name():
	return self.land_name

func get_owners():
	return self.shares

func get_color():
	return self.color

func get_image():
	return self.image

func get_video():
	return self.video

func get_buttons():
	return self.buttons

func get_description():
	return self.description

func generate_description():
	var text : String = ""
	if(!resources.is_empty()):
		text = "This land generates:\n"
		for k in resources.keys():
			text = text + "- " + resources[k][1] + " " + k + "\n"
	self.description = text

func get_land_owner():
	return self.land_owner

func set_land_owner(player : Player):
	self.land_owner = player

func get_available_share() -> float:
	var rest : float = 1
	for k in shares.keys():
		rest = rest - shares[k]
	return rest

func get_resources():
	return self.resources

func set_buttons_generic():
	var interactions : Array = ["Contest", "Purchase", "Build"]
	for i in interactions:
		var b = Button.new()
		b.set_text(i)
		b.set_action_mode(0)
		b.get_pressed().connect(self.some_methode())
		buttons.append(b)

func some_methode():
	pass

#gameplay functions
func prepare(): #called before generate
	pass

func freeze(turns : int):
	frozen_turns = frozen_turns + turns
	can_generate = false

func decrement_freeze():
	frozen_turns = frozen_turns - 1
	if(frozen_turns == 0):
		can_generate = true

func generate(): #called on new round
	if !can_generate:
		self.decrement_freeze()
		return
	for k in resources.keys():
		resources[k][0] = resources[k][0] + resources[k][1]
		supply_shares(k, resources[k][1])

func supply_shares(res : String, value : float):
	for s in shares:
		var your_share : float = shares[s] * value
		s.append_resource(res, your_share) 
