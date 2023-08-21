extends Node

class_name Turf

#general
var land_name : String
var description : String
var color : Color
var font_color : Color
var image : Sprite2D
var video : String
var audio : String
var play_at : int
var button_id : Array

#stats
var square : int
var price : float
var resources : Dictionary
var firearms : int
var is_land : bool
var inventory : Dictionary

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
	image = Sprite2D.new()
	color = Color(255, 255, 255, 1)
	font_color = Color(255, 255, 255, 1)
	video = ""
	audio = ""
	play_at = 0
	button_id = [1, 2, 3]
	
	#stats
	square = -1
	resources = {}
	price = 0
	firearms = 0
	is_land = true
	inventory = {}
	
	#shares
	land_owner = null
	shares = {}
	is_purchased = false
	
	#per turn
	can_generate = true
	frozen_turns = 0

#Setget
func get_square():
	return self.square

func get_inventory():
	return self.inventory

func get_land_name():
	return self.land_name

func get_color():
	return self.color

func get_color_raw():
	var c = self.color / 255
	c.a = 1
	return c

func get_font_color_raw():
	var c = self.font_color / 255
	c.a = 1
	return c

func set_image(path : String):
	var texture : Texture2D = load(path)
	self.image.set_texture(texture)

func get_image():
	return self.image

func get_video():
	return self.video

func get_audio():
	return self.audio

func get_buttons():
	return self.button_id

func get_corresponding_buttons(turn : int):
	var corr : Array
	if(is_land):
		for b in button_id:
			match(b):
				1: #Contest
					if(land_owner != null):
						if(turn == land_owner.get_order()):
							continue
				2: #Purchase
					if(is_purchased):
						continue
				3: #Build
					if(land_owner == null):
						continue
					if(turn not in self.get_owners_order()):
						continue
			corr.append(button_id[b])
	else:
		corr = button_id
	return corr

func set_buttons(btn_id : Array):
	self.button_id = btn_id

func set_is_land(b : bool):
	self.is_land = b

func get_is_land():
	return self.is_land

func set_play_at(at : int):
	self.play_at = at

func get_play_at():
	return self.play_at

func get_description():
	return self.description

func generate_description():
	var text : String = ""
	if(!resources.is_empty()):
		text = "This land generates:\n"
		for k in resources.keys():
			text = text + "- " + str(resources[k][1]) + " " + k + "\n"
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

func set_price(p : int):
	self.price = p

func get_firearms():
	return self.firearms

func set_firearms(fa : int):
	self.firearms = fa

#gameplay functions
func prepare(): #called before generate
	pass

func on_pass(player : Player, panel : Panel):
	pass

func on_enter(player : Player):
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
