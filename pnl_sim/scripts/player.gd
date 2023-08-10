extends Node

class_name Player

var player_id : int
var player_name : String
var order : int
var square : int
var previous_square : int
var step : float = -0.12

var resources : Dictionary = {
	"ients-clit" : 0, 
	"rep" : 0, 
	"firearms" : 0, 
	"dirty" : 0,
	"clean" : 0,
	"weed" : 0,
	"yayo" : 0
	}

func _init():
	square = 0
	previous_square = 0
	init_resources()

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

func append_resource(res_name : String, value : float): #add rpc
	resources[res_name] = resources[res_name] + value
	if(player_id == multiplayer.get_unique_id()):
		update_navbar(res_name, resources[res_name])
	rpc("sync_resources", res_name, value)

func deplete_resource(res_name : String, value : float): #add rpc
	resources[res_name] = resources[res_name] - value
	if(player_id == multiplayer.get_unique_id()):
		update_navbar(res_name, resources[res_name])
	rpc("sync_resources", res_name, value)

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
		passed.append(square)
		if(square > 39):
			square = 0
		await get_tree().create_timer(0.4).timeout
	return passed

func print_self():
	print("ID: ", self.player_id)
	print("NAME: ", self.player_name)
	print("ORDER: ", self.order)
	print("-------------------------------")
