extends Control

var playScene : String = "res://Scenes/dev/playground.tscn"

@export var fade_time := 2.0

@onready var image_a: NinePatchRect = $FadedBg
@onready var image_b: NinePatchRect = $IconBg

func _ready():
	image_b.modulate.a = 0.0
	await get_tree().create_timer(1.0).timeout
	fade_to_image_b()

func fade_to_image_b():
	var tween := create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(image_a, "modulate:a", 0.0, fade_time)
	tween.tween_property(image_b, "modulate:a", 1.0, fade_time)


func _process(delta: float) -> void:
	pass

func _on_quit_pressed() -> void:
	print("Exit pressed")
	get_tree().quit()


func _on_play_pressed() -> void:
	GF.load_scene(playScene)
