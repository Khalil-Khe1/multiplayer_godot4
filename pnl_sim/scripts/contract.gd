extends Node

class_name Contract

var recipient : int #id
var pay : int #dirty money pay
var supply : int
var res_name : String #weed/coke/arms
var square : int #land that triggers the popup
var turns : int = 10

func set_recipient(rec : int):
	self.recipient = rec

func get_recipient():
	return self.recipient

func set_pay(p : int):
	self.pay = p

func get_pay():
	return self.pay

func set_supply(supp : int, res : String):
	self.supply = supp
	self.res_name = res

func get_supply():
	return self.supply

func get_res_name():
	return self.res_name

func set_square(s : int):
	self.square = s

func get_square():
	return self.square

func decrement_turns():
	turns = turns - 1

func get_turns():
	return self.turns
