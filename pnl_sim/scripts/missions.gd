extends Node

class_name MissionRepo

var players : Array
var shares : Shares
var trades : TradeController
var cards #future implementation

var missions : Array

func declare(type : int, obj : Variant, player : Player):
	var description : String
	var mission : Mission = Mission.new()
	mission.set_player(player)
	mission.set_type(type)
	mission.set_requested(obj)
	match(type):
		0:
			var req : Turf = mission.get_requested()
			mission.set_description("Get me " + req.get_land_name())
			mission.get_confirm().pressed.connect(
				func():
					if (req.get_square() not in mission.get_player().get_inventory()["lands"]):
						return
					var item : Tradeable
					item.set_up(req, 0, 1, 0, player, null)
					trades.trade(item)
					trades.trade(mission.get_payout())
					missions.erase(mission)
			)
		1:
			mission.set_description("Imprison x")
		2:
			mission.set_description("Raid x")
	missions.append(mission)

func list(id : int):
	var res : Array
	for m in missions:
		if(m.get_player().get_id() == id):
			res.append(m)
	return res
