extends Node

class_name ContractController

var contracts : Array
var upgrades : Dictionray = { #supplier : [tier 1, tier 2]
	"cia" : [0, 0],
	"escobar" : [0, 0]
}

func check(contract : Contract, player : Player) -> bool:
	if(player.get_resources()["dirty"] > contract.get_pay()):
		player.deplete_resource("dirty", contract.get_pay())
		player.append_resource(contract.get_res_name(), contract.get_supply())
		return true
	return false

func generate(player : Player):
	var contract : Contract = Contract.new()
	match(player.get_square()):
		0:
			if(player.get_rank() == 1):
				var amount : int = (upgrades["cia"][0] * 5000)
				if(amount == 0):
					amount = 1000
				contract.set_pay(16 * amount)
				contract.set_recipient(player.get_id())
				contract.set_square(0)
				contract.set_supply(amount, "coke")
			else:
				var amount : int = (upgrades["cia"][1] * 3000)
				if(amount == 0):
					amount = 1000
				contract.set_pay(3 * amount)
				contract.set_recipient(player.get_id())
				contract.set_square(0)
				contract.set_supply(amount, "weed")
		22:
			var amount : int = (upgrades["escobar"][0] * 5000) + 3000
			contract.set_pay(24 * amount)
			contract.set_recipient(player.get_id())
			contract.set_square(0)
			contract.set_supply(amount, "coke")
	player.append_contract(contract)
