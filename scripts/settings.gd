extends Node

var default_settings := {
	"audio/master_volume": 100.0,
}

var current_settings := {}

func _ready() -> void:
	load_settings()


func load_settings():
	var cfg = ConfigFile.new()
	var err = cfg.load("user://settings.cfg")
	
	if err != OK:
		print("No settings file found. Saving default settings.")
		for key in default_settings.keys():
			var section = key.get_slice("/", 0)
			var name = key.get_slice("/", 1)
			cfg.set_value(section, name, default_settings[key])
		cfg.save("user://settings.cfg")
	
	for key in default_settings.keys():
		var section = key.get_slice("/", 0)
		var name = key.get_slice("/", 1)
		current_settings[key] = cfg.get_value(section, name, default_settings[key])
		
	apply_master_volume()


func set_setting(key: String, value):
	current_settings[key] = value
	
	var cfg = ConfigFile.new()
	cfg.load("user://settings.cfg")
	
	var section = key.get_slice("/", 0)
	var name = key.get_slice("/", 1)
	cfg.set_value(section, name, value)
	cfg.save("user://settings.cfg")
	
	if(key == "audio/master_volume"):
		apply_master_volume()


func get_setting(key: String, default_value = null):
	if current_settings.has(key):
		return current_settings[key]
	return default_value


func reset_to_defaults():
	current_settings.clear()

	var cfg := ConfigFile.new()

	for key in default_settings.keys():
		var section = key.get_slice("/", 0)
		var name = key.get_slice("/", 1)

		var value = default_settings[key]
		current_settings[key] = value
		cfg.set_value(section, name, value)

	cfg.save("user://settings.cfg")


func apply_master_volume():
	var value = get_setting("audio/master_volume", 1.0)
	var bus := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value * 0.01))
