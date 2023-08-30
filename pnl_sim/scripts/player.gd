extends Node

class_name Player

#ID
var player_id : int
var player_name : String
var order : int

#MAP
var square : int
var previous_square : int
var step : float = -0.12

#GAMEPLAY
var resources : Dictionary = {
	"ients-clit" : 0, 
	"rep" : 0, 
	"firearms" : 0, 
	"dirty" : 0,
	"clean" : 0,
	"weed" : 0,
	"yayo" : 0
	}

var inventory : Dictionary = {
	"lands" : [],
	"cards" : []
}

var start : Array #Array of callables

var boost : Dictionary = {}

var promises : Array #Array of tradeables that are to be repaid per turn
var stars : int
var is_imprisoned : bool
var is_stunned : bool

func _init():
	square = 0
	previous_square = 0
	stars = 0
	is_imprisoned = false
	is_stunned = false
	init_resources()

func set_player_name(name : String):
	self.player_name = name

func get_player_name():
	return self.player_name

func set_id(id : int):
	self.player_id = id

func get_id():
	return self.player_id

func get_order():
	return self.order

func set_order(o : int):
	self.order = o

func set_square(s : int):
	self.square = s

func get_square():
	return self.square

func get_previous_square():
	return self.previous_square

func get_resources():
	return self.resources

func get_inventory():
	return self.inventory

func get_promises():
	return self.promises

func set_stars(s : int):
	self.stars = s

func get_stars():
	return self.stars

func append_boost(amount : float, turns : int):
	self.boost[amount] = self.boost[amount] + turns

func decrement_boost(amount : float):
	if(self.boost[amount] != 0):
		self.boost[amount] = self.boost[amount] - 1

func get_boost():
	return self.boost

func set_is_imprisoned(ii : bool):
	self.is_imprisoned = ii

func get_is_imprisoned():
	return self.is_imprisoned

func set_is_stunned(s : bool):
	self.is_stunned = s

func get_is_stunned():
	return self.is_stunned

func append_start_callables(callable : Callable):
	self.start.append(callable)

func erase_start_callables():
	self.start.clear()

func append_inventory(category : String, id : int):
	self.inventory[category].append(id)

func erase_inventory(category : String, id : int):
	self.inventory[category].erase(id)

func init_resources(): #testing
	for k in resources.keys():
		resources[k] = 100000

func init_navbar():
	var navbar = get_tree().get_root().get_node("server/control/game_ui/navbar")
	for k in resources:
		var amount : String = ""
		if k == "rep":
			continue
		if k == "dirty":
			amount = "$"
		if k == "clean":
			amount = "$$"
		amount = amount + str(resources[k])
		navbar.get_node(k + "/data").set_text(amount)

func update_navbar(res_name : String, value : float):
	var navbar = get_tree().get_root().get_node("server/control/game_ui/navbar")
	var amount : String = ""
	if res_name == "rep":
		return
	if res_name == "dirty":
		amount = "$"
	if res_name == "clean":
		amount = "$$"
	amount = amount + str(value)
	navbar.get_node(res_name + "/data").set_text(amount)

func set_resource(res_name : String, value : float):
	resources[res_name] = value
	if(player_id == multiplayer.get_unique_id()):
		update_navbar(res_name, resources[res_name])
	rpc("sync_resource", res_name, resources[res_name])

func append_resource(res_name : String, value : float): #add rpc
	resources[res_name] = resources[res_name] + value
	if(player_id == multiplayer.get_unique_id()):
		update_navbar(res_name, resources[res_name])
	rpc("sync_resource", res_name, resources[res_name])

func deplete_resource(res_name : String, value : float): #add rpc
	resources[res_name] = resources[res_name] - value
	if(player_id == multiplayer.get_unique_id()):
		update_navbar(res_name, resources[res_name])
	rpc("sync_resource", res_name, resources[res_name])

@rpc("any_peer")
func sync_resource(res_name : String, value : float):
	resources[res_name] = value

func resource_least() -> String:
	var key : String
	var max : float = 10000000
	for k in resources.keys():
		if(resources[k] < max):
			max = resources[k]
			key = k
	return key

func move(howmuch : int):
	var passed : Array
	previous_square = square
	if(howmuch == 0):
		return
	var s : Vector3 = Vector3(0, 0, 0)
	for i in howmuch:
		if(square in range(0, 10)):
			s = Vector3(0, 0, 1)
		if(square in range(10, 20)):
			s = Vector3(-1, 0, 0)
		if(square in range(20, 30)):
			s = Vector3(0, 0, -1)
		if(square in range(30, 40)):
			s = Vector3(1, 0, 0)
		self.position = self.position + (s * step)
		rpc("sync_move", self.position)
		square = square + 1
		if(square > 39):
			square = 0
		passed.append(square)
		await get_tree().create_timer(0.4).timeout
	return passed

func move_to(destination : int):
	await move((self.square + destination) % 40)

@rpc("any_peer")
func sync_move(pos : Vector3):
	self.position = pos
	
func check_imprisoned(howmuch : int):
	if(is_imprisoned):
		if(howmuch == 12):
			stars = 0
			is_imprisoned = false
		else:
			stars = stars - 1
	return is_imprisoned
	

func sell():
	var f : int = self.resources["ients-clit"]
	var w : int = self.resources["weed"]
	var c : int = self.resources["coke"]
	var weed_price : float
	var coke_price : float
	var total_boost : float = 0
	for k in boost.keys():
		total_boost = total_boost + k
	if(f < w):
		self.resources["weed"] = w - f
		self.resources["dirty"] = f * weed_price * (total_boost + 1)
	else:
		self.resources["weed"] = 0
		self.resources["dirty"] = w * weed_price * (total_boost + 1)
	if(f < c):
		self.resources["coke"] = c - f
		self.resources["dirty"] = f * coke_price * (total_boost + 1)
	else:
		self.resources["coke"] = 0
		self.resources["dirty"] = c * coke_price * (total_boost + 1)

func deplete_stock():
	var weed_price : float
	var coke_price : float
	var total_boost : float = 0
	for k in boost.keys():
		total_boost = total_boost + k
	self.resources["dirty"] = self.resources["weed"] * weed_price * (total_boost + 1)
	self.resources["dirty"] = self.resources["coke"] * coke_price * (total_boost + 1)
	self.resources["weed"] = 0
	self.resources["coke"] = 0

func turn_start():
	for c in start:
		var callable : Callable = c
		callable.call()
	self.erase_start_callables()

func print_self():
	print("ID: ", self.player_id)
	print("NAME: ", self.player_name)
	print("ORDER: ", self.order)
	print("-------------------------------")
