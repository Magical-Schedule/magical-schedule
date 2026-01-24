extends Node

var sessions := []   

func _ready():
	load_sessions()

func add_session(entry: Dictionary):
	sessions.append(entry)
	save_sessions()

func save_sessions():
	var file = FileAccess.open("user://session_log.save", FileAccess.WRITE)
	if file:
		file.store_var(sessions)

func load_sessions():
	if FileAccess.file_exists("user://session_log.save"):
		var file = FileAccess.open("user://session_log.save", FileAccess.READ)
		sessions = file.get_var()
