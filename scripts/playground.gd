extends Node2D

@onready var pauseMenu = get_node("CanvasLayer/PauseMenu")

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
		if event.is_action_pressed("pause"):
			print("PAUSING")
			pauseMenu.open_menu()
