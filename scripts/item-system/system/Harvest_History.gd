extends Node

signal history_changed

var harvested := {}

func _ready():
	print("HarvestHistory ready")
	load_history()

func add_harvest(item_id: String, amount: int = 1) -> void:
	if harvested.has(item_id):
		harvested[item_id] += amount
	else:
		harvested[item_id] = amount

	save_history()
	emit_signal("history_changed")  

func get_all() -> Dictionary:
	return harvested

func save_history() -> void:
	var file = FileAccess.open("user://harvest_history.save", FileAccess.WRITE)
	if file:
		file.store_var(harvested)

func load_history() -> void:
	if FileAccess.file_exists("user://harvest_history.save"):
		var file = FileAccess.open("user://harvest_history.save", FileAccess.READ)
		if file:
			var data = file.get_var()
			if data is Dictionary:
				harvested = data
			else:
				harvested = {}

func reset_history() -> void:
	harvested.clear()
	save_history()
	emit_signal("history_changed")
