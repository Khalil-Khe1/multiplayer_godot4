extends Card

var upgrade : int = 1

func _init():
	default_init()
	id = 10
	title = "NARCOS"
	description = "start coke deal with the columbians (minimum 5 keys)"
	count = 1
	tier = 3

func on_activate():
	var scene : Control = load("res://scenes/card_activate.tscn").instantiate()
	var current : Player = get_node("/root/server/gamescene").get_current()
	description = "[center]" + description + "\nCurrent: " 
	description = description + str(upgrade * 5) + "kg of coke for $$" + str(upgrade * 5 * 16000)
	scene.get_node("Panel/description").set_text(description)
	scene.get_node("Panel/combo").set_visible(false)
	scene.get_node("Panel/confirm").set_action_mode(0)
	scene.get_node("Panel/confirm").pressed.connect(
		func():
			var contract : Contract = Contract.new()
			contract.set_recipient(current.get_id())
			contract.set_supply(5, "coke")
			contract.set_pay(5 * 16000)
			contract.set_square(22)
			contract.set_turns(10)
			if(upgrade < 10):
				upgrade = upgrade + 1
			current.append_contract(contract)
			current.get_inventory()["cards"].remove(id)
			self.is_taken = false
			scene.get_parent().remove_child(scene)
			scene.queue_free()
			
	)
	scene.get_node("Panel/exit").set_action_mode(0)
	scene.get_node("Panel/exit").pressed.connect(
		func():
			scene.get_parent().remove_child(scene)
			scene.queue_free()
	)
