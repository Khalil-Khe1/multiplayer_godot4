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

var promises : Array

func _init():
	square = 0
	previous_square = 0
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
	rpc("sync_resources", res_name, resources[res_name])

func append_resource(res_name : String, value : float): #add rpc
	resources[res_name] = resources[res_name] + value
	if(player_id == multiplayer.get_unique_id()):
		update_navbar(res_name, resources[res_name])
	rpc("sync_resources", res_name, resources[res_name])

func deplete_resource(res_name : String, value : float): #add rpc
	resources[res_name] = resources[res_name] - value
	if(player_id == multiplayer.get_unique_id()):
		update_navbar(res_name, resources[res_name])
	rpc("sync_resources", res_name, resources[res_name])

@rpc("any_peer")
func sync_resource(res_name : String, value : float):
	resources[res_name] = value

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
		square = square + 1
		if(square > 39):
			square = 0
		passed.append(square)
		await get_tree().create_timer(0.4).timeout
	return passed

func print_self():
	print("ID: ", self.player_id)
	print("NAME: ", self.player_name)
	print("ORDER: ", self.order)
	print("-------------------------------")
