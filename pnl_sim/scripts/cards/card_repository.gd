extends Node

class_name CardRepo

var luck_pile : Array

func _init():
	pass

func init_luck():
	var path = "res://scripts/cards/luck"
	var dir = DirAccess.open(path)
	for f in dir.get_files():
		var card : Card = load(path + "/" + f).new()
		for c in card.get_count():
			luck_pile.append(card)

func find_luck(id : int) -> Card:
	for l in luck_pile:
		if(l.get_id() == id):
			return l
	return null

func activate_card(card : Card, player : Player) -> Control:
	if(!card.get_passive()):
		var scene : Control = card.on_activate()
		player.get_inventory()["cards"].erase(card.get_id())
		luck_pile.append(card)
		return scene
	return null

func card_ui(card : Card) -> Control:
	var scene : Control = load("res://scenes/card.tscn").instantiate()
	scene.get_node("panel/title").set_text(card.get_title())
	scene.get_node("panel/description").set_text(card.get_description())
	return scene

func append_card(player : Player, card : Card):
	player.get_inventory()["cards"].append(card.get_id())
	card.set_taken(true)

func erase_card(player : Player, card : Card):
	player.get_inventory()["cards"].erase(card.get_id())
	card.set_taken(false)
	
