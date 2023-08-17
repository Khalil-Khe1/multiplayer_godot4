extends Node

class_name MissionRepo

var players : Array
var npcs : Array #0 : CIA / 1 : SA3OUD
var shares : Shares
var trades : TradeController
var cards #future implementation

var missions : Array

@rpc("any_peer")
func sync(npc_array : Array, missions_array : Array):
	npcs = npc_array
	missions = missions_array

func set_npc(npc_array : Array):
	for n in npc_array:
		for i in range(5):
			declare(0, n)
		npcs.append(n)
	rpc("sync", npcs, missions)

func declare(type : int, npc : Player):
	var rng = RandomNumberGenerator.new()
	rng.set_seed(hash(Time.get_ticks_msec() * rng.randi()))
	var mission : Mission = Mission.new()
	mission.set_type(type)
	mission.set_npc(npc)
	match(type):
		0:
			var req : Turf = shares.find(rng.randi_range(0, 40))
			mission.set_requested(req)
			mission.set_description("Get me " + req.get_land_name())
			mission.set_payout(declare_payout(1, npc))
			mission.get_confirm().pressed.connect(
				func():
					if (req.get_square() not in mission.get_player().get_inventory()["lands"]):
						return
					var item : Tradeable
					item.set_up(req, 0, 1, 0, mission.get_player(), mission.get_npc())
					trades.trade(item)
					trades.trade(mission.get_payout())
					replace_mission(mission, npc)
			)
		1:
			var req : Player = players[rng.randi_range(0, players.size())]
			mission.set_requested(req)
			mission.set_payout(declare_payout(3, npc))
			mission.set_description("Imprison x")
			mission.get_confirm().pressed.connect(
				func():
					if (!req.get_is_imprisoned()):
						return
					trades.trade(mission.get_payout())
					replace_mission(mission, npc)
			)
		2:
			mission.set_description("Raid x")
		3: #get card
			pass
	missions.append(mission)

func replace_mission(mission : Mission, npc : Player):
	missions.erase(mission)
	declare(0, npc)
	rpc("sync", npcs, missions)

func declare_payout(tier : int, npc : Player) -> Tradeable:
	var reward : Variant
	var resources : Dictionary = {
		"ients-clit" : 120, 
		"rep" : 10, 
		"firearms" : 80, 
		"dirty" : 15000,
		"clean" : 5000,
		"weed" : 1000,
		"yayo" : 200
	}
	var payout : Tradeable = Tradeable.new()
	var rng = RandomNumberGenerator.new()
	rng.set_seed(hash(Time.get_ticks_msec() * rng.randi()))
	var key : String = resources.keys()[rng.randi_range(0, resources.keys().size())]
	match(tier):
		1:
			var amount = rng.randi_range(resources[key], int(resources[key] * 2.5))
			payout.set_up(key, 1, amount, 0, npc, null)
		2:
			var amount = rng.randi_range(resources[key] * 4, resources[key] * 8)
			payout.set_up(key, 1, amount, 0, npc, null)
		3:
			if(!npc.get_inventory()["lands"].is_empty()):
				var arr : Array = npc.get_inventory()["lands"]
				reward = arr[rng.randi_range(0, arr.size())]
				payout.set_up(reward, 0, 1, 0, npc, null)
			else:
				var amount = rng.randi_range(resources[key] * 15, int(resources[key] * 24))
				payout.set_up(key, 1, amount, 0, npc, null)
	return payout

func list(id : int):
	var res : Array
	for m in missions:
		if(m.get_player().get_id() == id):
			res.append(m)
	return res
