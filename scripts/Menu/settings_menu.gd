extends Control

@onready var click := $ClickSound

@export var fade := 0.35

func _ready() -> void:
	modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, fade)


func _process(delta: float) -> void:
	pass


func _input(event):
	if event.is_action_pressed("pause"):
		close_menu()


func close_menu() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, fade)
	
	await tween.finished
	queue_free()


func _on_back_pressed() -> void:
	close_menu()


func _on_any_button_pressed():
	click.play()


func _on_reset_pressed() -> void:
	pass
