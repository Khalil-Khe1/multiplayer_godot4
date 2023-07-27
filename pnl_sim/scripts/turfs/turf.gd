extends Node

class_name Turf

var land_name : String = "Turf"

var square : int
var price : float
var resources : Dictionary

var land_owner : Player
var shares : Dictionary


var can_generate : bool = true
var frozen_turns : int

func _init():
	square = -1
	resources = {}
	price = 0
	frozen_turns = 0

#Setget
func get_square():
	return self.square

func get_land_name():
	return self.land_name

func get_owners():
	return self.shares

func set_land_owner(player : Player):
	self.land_owner = player

func get_available_share() -> float:
	var rest : float = 1
	for k in shares.keys():
		rest = rest - shares[k]
	return rest

func get_resources():
	return self.resources

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
