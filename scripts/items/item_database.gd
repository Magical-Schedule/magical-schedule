class_name ItemDatabase extends Node
## Manages the loading and retrieval of game items from JSON data.


# Signals usually come first
signal database_loaded

# Constants in ALL_CAPS
const DATA_PATH = "res://data/"


# --- Public Variables ---

var items: Dictionary = {}


# --- Public Methods ---

func get_item(item_id: String) -> Item:
	if items.has(item_id):
		return items[item_id].duplicate()  # Return a copy
	return null


# --- Private Variables ---

var _debug_mode: bool = true


# --- Private Methods ---

func _log(message: String, is_error: bool = false) -> void:
	# Only print if our private toggle is on
	if _debug_mode:
		if is_error:
			printerr("[ItemDatabase ERROR] ", message)
		else:
			print("[ItemDatabase] ", message)

"""
func _load_from_json(path: String):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var content = file.get_as_text()
		file.close() # Optional in Godot 4 as it closes when out of scope, but good practice
		
		var json_instance = JSON.new()
		var error = json_instance.parse(content)
		
		if error == OK:
			return json_instance.data
		else:
			print("[ERROR] JSON Parse Error: ", 
				json_instance.get_error_message(), 
				" at line ", json_instance.get_error_line())
			return null
	
	print("[ERROR] File does not exist: ", path)
	return null
"""

func _load_all_items() -> void:
	var dir = DirAccess.open(DATA_PATH)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			# Check if it's a file and not a directory
			if not dir.current_is_dir():
				# We check for .tres OR .res (the compiled version)
				# and ignore the .import files
				if file_name.ends_with(".tres") or file_name.ends_with(".res"):
					# We strip ".remap" if Godot added it during export
					var clean_path = DATA_PATH + file_name.replace(".remap", "")
					var item = load(clean_path)
					
					if item is Item: # Type check for safety
						items[item.id] = item
						
						if _debug_mode:
							_log("[INFO] Registered item: %s" % item.name, false)
						
			file_name = dir.get_next()
			if file_name == "": break
	else:
		_log("[ERROR] Could not open path: %s" % DATA_PATH, true)

func _create_default_items():
	# var data = _load_from_json("res://assets/weapons/weapons-data.json")
	_load_all_items()

func _ready():
	_create_default_items()
