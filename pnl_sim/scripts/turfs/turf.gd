extends Node

class_name Turf

#general
var land_name : String
var description : String
var color : Color
var image : Sprite2D
var video : VideoStream
var buttons : Array

#stats
var square : int
var price : float
var resources : Dictionary
var firearms : int

#shares system
var land_owner : Player
var shares : Dictionary
var is_purchased : bool

#per turn status
var can_generate : bool
var frozen_turns : int

func _init():
	init_default()

func init_default():
	#general
	land_name = "Turf"
	generate_description()
	image = null
	color = Color.WHITE
	#video.set_file("")
	set_buttons_generic()
	
	#stats
	square = -1
	resources = {}
	price = 0
	firearms = 0
	
	#shares
	land_owner = null
	shares = {}
	is_purchased = false
	
	#per turn
	can_generate = true
	frozen_turns = 0

func init_general():
	firearms = self.square * 2

#Setget
func get_square():
	return self.square

func get_land_name():
	return self.land_name

func get_color():
	return self.color

func get_color_raw():
	var c = self.color / 255
	c.a = 1
	return c

func get_image():
	return self.image

func get_video():
	return self.video

func get_buttons():
	return self.buttons

func get_corresponding_buttons(turn : int):
	var corr : Array
	for b in buttons:
		match(b.get_text()):
			"Contest":
				if(land_owner != null):
					if(turn == land_owner.get_order()):
						continue
			"Purchase":
				if(is_purchased):
					continue
			"Build":
				if(land_owner == null):
					continue
				if(turn not in self.get_owners_order()):
					continue
		corr.append(b)
	return corr

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

func get_owners():
	return self.shares

func get_owners_order():
	var orders : Array
	for o in self.shares.keys():
		orders.append(o.get_order())
	return orders

func get_available_share() -> float:
	var rest : float = 1
	for k in shares.keys():
		rest = rest - shares[k]
	return rest

func get_is_purchased():
	return self.is_purchased

func set_is_purchased(state : bool):
	self.is_purchased = state

func get_resources():
	return self.resources

func get_price():
	return self.price

func get_firearms():
	return self.firearms

func set_firearms(fa : int):
	self.firearms = fa

func set_buttons_generic():
	var interactions : Array = ["Contest", "Purchase", "Build"]
	for i in interactions:
		var b = Button.new()
		b.set_text(i)
		b.set_action_mode(0)
		var callable = Callable(self, "_button_pressed")
		b.pressed.connect(callable.bind(i))
		buttons.append(b)

func _button_pressed(name : String): #IMPLEMENT INTERACTIONS HERE
	match(name):
		"Contest":
			pass
		"Purchase":
			pass
		"Build":
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
