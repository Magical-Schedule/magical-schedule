extends "res://scripts/Menu/menu.gd"

var playScene : String = "res://Scenes/dev/playground.tscn"

@onready var image_a: NinePatchRect = $FadedBg
@onready var image_b: NinePatchRect = $IconBg
@onready var fadeInRect : ColorRect = $FadeInRect

func _ready():
	image_b.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(fadeInRect, "modulate:a", 0.0, 0.5)
	await get_tree().create_timer(0.5).timeout
	fade_to_image_b()

func fade_to_image_b():
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(image_a, "modulate:a", 0.0, fade_time)
	tween.tween_property(image_b, "modulate:a", 0.8, fade_time)

func _on_quit_pressed() -> void:
	quit()

func _on_play_pressed() -> void:
	fade_then_load_scene(playScene)
