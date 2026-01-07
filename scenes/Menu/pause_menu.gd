extends "res://scenes/Menu/menu.gd"

var menuScene : String = "res://scenes/Menu/MainMenu.tscn"

func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass

func _on_quit_to_menu_pressed() -> void:
	fade_then_load_scene(menuScene)

func _on_quit_to_desktop_pressed() -> void:
	quit()
