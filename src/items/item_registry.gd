## Item registry of all possible items
extends Node

var _database: Dictionary = {} # id: Item (Master Resources)

func _ready():
	_load_items_recursive("res://data/items/")

## Loading items recursively, paths and .tres files
func _load_items_recursive(path: String):
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir():
				_load_items_recursive(path + file_name + "/")
				
			elif file_name.ends_with(".tres"):
				var full_path = path + file_name
				var res = load(full_path)
				if res is Item:
					_database[res.id] = res
					print("Registered Item: ", res.id, " from ", full_path)
					
			file_name = dir.get_next()

## Creating an instance which returns a unique copy
func create_instance(id: String) -> Item:
	if not _database.has(id):
		push_error("Item ID not found: " + id)
		return null
	
	var master_res = _database[id]
	var instance = master_res.duplicate(true) # Deep copy including components
	
	if instance.quantity_data:
		instance.quantity_data.initialize()
		
	return instance
