extends Node

@export var main_menu_scene: PackedScene
var current_scene: Node = null

func _ready():
	load_main_menu()


func load_main_menu():
	for child in get_children():
		child.queue_free()
	
	if main_menu_scene:
		var menu_instance = main_menu_scene.instantiate()
		add_child(menu_instance)
	else:
		push_warning("Main Menu scene not assigned in GameFlow.gd")


func load_scene(path: String) -> void:
	if not ResourceLoader.exists(path):
		push_error("Scene does not exist: %s" % path)
		return

	get_tree().change_scene_to_file(path)
