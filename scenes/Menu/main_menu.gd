extends Control

var playScene : String = "res://Scenes/dev/playground.tscn"

@export var fade_time := 1.5
@export var fade_out := 0.5

@onready var image_a: NinePatchRect = $FadedBg
@onready var image_b: NinePatchRect = $IconBg
@onready var fade: ColorRect = $Fade

func _ready():
	fade.modulate.a = 0.0
	fade.visible = true
	image_b.modulate.a = 0.0
	
	await get_tree().create_timer(0.5).timeout
	fade_to_image_b()

func fade_to_image_b():
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(image_a, "modulate:a", 0.0, fade_time)
	tween.tween_property(image_b, "modulate:a", 0.8, fade_time)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_play_pressed() -> void:
	fade_then_load_scene(playScene)

func fade_then_load_scene(scene_path: String) -> void:
	fade.modulate.a = 0.0
	fade.visible = true
	
	await get_tree().process_frame
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(fade, "modulate:a", 1.0, fade_out)
	
	await tween.finished
	
	GF.load_scene(scene_path)
