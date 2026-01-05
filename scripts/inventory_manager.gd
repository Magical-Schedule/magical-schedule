extends Node
# Nastavi kot Autoload:  Project > Project Settings > Autoload > Add

var inventory: Dictionary = {}

func add_item(item_name: String, amount: int):
	if item_name in inventory:
		inventory[item_name] += amount
	else: 
		inventory[item_name] = amount
	print("✅ Dodano v inventory: ", item_name, " x", amount)

func get_item_count(item_name: String) -> int:
	return inventory.get(item_name, 0)

func remove_item(item_name: String, amount: int) -> bool:
	if get_item_count(item_name) >= amount:
		inventory[item_name] -= amount
		return true
	return false
