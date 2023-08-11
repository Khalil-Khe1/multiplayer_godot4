extends Node

class_name MissionRepo

var players : Array
var shares : Shares
var cards #future implementation

var missions : Array

func declare(type : String, obj : Variant):
	var description : String
	var mission : Mission = Mission.new()
	match(type):
		"get":
			description = "Get me x"
			mission.get_confirm().pressed.connect(
				func():
					pass
					#mission.get_player().get_inventory("lands")[obj] != null => confirm mission => payout
			)
		"imprison":
			description = "Imprison x"
		"raid":
			description = "Raid x"
