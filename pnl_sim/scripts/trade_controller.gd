extends Node

class_name TradeController

func check_scam(player : Player) -> bool:
	var m : LeM = get_node("/root/Server/gamescene").get_cards().find_luck(17)
	if((player.get_inventory()["cards"].has(17))&&(m.get_active())):
		return true
	return false

func resolve_scam(scammer : Player):
	if(scammer != null):
		var card_repo : CardRepo = get_node("/root/Server/gamescene").get_cards()
		var m : LeM = card_repo.find(17)
		m.set_active(false)
		card_repo.erase_card(scammer, card_repo.find(17))

func process_trade(items : Array, shares : Shares):
	var scammer : Player = null
	for i in items:
		var item : Tradeable = i
		if(!check(item)):
			return
		if(check_scam(item.get_trader())):
			scammer = item.get_trader()
			continue
		trade(item, shares)
	resolve_scam(scammer)

func trade(item : Tradeable, shares : Shares):
	match(item.get_type()):
		0:
			var land : Turf = item.get_object()
			shares.trade_share(item.get_trader(), item.get_recepient(), item.get_amount(), land)
		1:
			if(item.get_turns() == 0):
				item.get_recepient().append_resource(item.get_object(), item.get_amount())
				item.get_trader().deplete_resource(item.get_object(), item.get_amount())
			else:
				item.get_trader().get_promises().append(item)
		2:
			pass

func trade_obama(items : Array):
	for i in items:
		var item : Tradeable = i
		if(!check(item)):
			return
		match(item.get_type()):
			0:
				var land : Turf = item.get_object()
				item.get_trader().erase_inventory("lands", land.get_square())
			1:
				if(item.get_turns() == 0):
					item.get_trader().deplete_resource(item.get_object(), item.get_amount())
				else:
					item.get_trader().get_promises().append(item)
			2:
				pass

func payout(item : Tradeable):
	match(item.get_type()):
		0:
			pass
		1:
			pass
		2:
			pass

func promise_controller(player : Player):
	for p in player.get_promises():
		if(p.get_recepient() != null):
			p.get_recepient().append_resource(p.get_object(), p.get_amount())
		p.get_trader().deplete_resource(p.get_object(), p.get_amount())
		p.set_turns(p.get_turns() - 1)
		if(p.get_turns() == 0):
			player.get_promises().erase(p)

func check(obj : Tradeable):
	var res : bool = false
	match(obj.get_type()):
		0:
			for id in obj.get_trader().get_inventory()["lands"]:
				if(id == obj.get_object().get_square()):
					return true
		1:
			if(obj.get_trader().get_resources()[obj.get_object()] > obj.get_amount()):
				return true
		2:
			for id in obj.get_trader().get_inventory()["cards"]:
				pass
#				if(id == obj.get_object().get_id()):
#					return true
	return false
