extends Node

class_name Player

var player_id : int
var player_name : String
var order : int
var square : int

var resources : Dictionary = {
	"ients-clit" : 0, 
	"rep" : 0, 
	"firearms" : 0, 
	"dirty" : 0,
	"clean" : 0,
	"leshit" : 0,
	"yayo" : 0
	}

func _init():
	square = 0

func get_id():
	return self.player_id

func get_order():
	return self.order

func set_order(o : int):
	self.order = o

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

func append_resource(res_name : String, value : float):
	resources[res_name] = resources[res_name] + value
	if(player_id == multiplayer.get_unique_id()):
		update_navbar(res_name, resources[res_name])

func deplete_resource(res_name : String, value : float):
	resources[res_name] = resources[res_name] - value
	if(player_id == multiplayer.get_unique_id()):
		update_navbar(res_name, resources[res_name])

func print_self():
	print("ID: ", self.player_id)
	print("NAME: ", self.player_name)
	print("ORDER: ", self.order)
	print("-------------------------------")
