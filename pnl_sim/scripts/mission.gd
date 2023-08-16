extends Node

class_name Mission

var requested : Variant
var description : String
var type : int
var confirm_btn : Button
var npc : Player
var player : Player
var payout : Tradeable

func set_npc(n : Player):
	self.npc = n

func get_npc():
	return self.npc

func set_player(p : Player):
	self.player = p

func get_player():
	return self.player

func get_confirm():
	return self.confirm_btn

func set_description(desc : String):
	self.description = desc

func get_description():
	return self.description

func set_type(t : int):
	self.type = t

func get_type():
	return self.type

func set_requested(req : Variant):
	self.requested = req

func get_requested():
	return self.requested

func set_payout(po : Tradeable):
	self.payout = po

func get_payout():
	return self.payout
