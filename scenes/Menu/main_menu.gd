extends Control

var playScene : String = "res://Scenes/dev/playground.tscn"

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass

func _on_quit_pressed() -> void:
	print("Exit pressed")
	get_tree().quit()


func _on_play_pressed() -> void:
	GF.load_scene(playScene)
