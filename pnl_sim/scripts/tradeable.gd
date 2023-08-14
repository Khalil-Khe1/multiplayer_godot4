extends Node

class_name Tradeable

var object : Variant
var type : int #0 : LAND / 1 : RES / 2 : CARD
var amount : float
var turns : int

var trader : Player
var recepient : Player

func set_up(o : Variant, ot : int, a : float, t : int, tr : Player, r : Player):
	self.object = o
	self.type = ot 
	self.amount = a
	self.turns = t
	self.trader = tr
	self.recepient = r

func set_object(o : Variant):
	self.object = o

func get_object():
	return self.object

func get_type():
	return self.type

func get_amount():
	return self.amount

func set_turns(t : int):
	self.turns = t

func get_turns():
	return self.turns

func get_trader():
	return self.trader

func get_recepient():
	return self.recepient
