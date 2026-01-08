extends Control

#Podrobna navodila za implementacijo menijev so na voljo pod clickup docs.
@export var fade_time := 1.0
@export var fade_out := 0.5

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func quit() -> void:
	get_tree().quit()

func fade_then_load_scene(scene_path: String) -> void:
	var fade := ColorRect.new()
	fade.color = Color(0,0,0)
	fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	fade.modulate.a = 0.0
	add_child(fade)
	
	await get_tree().process_frame
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(fade, "modulate:a", 1.0, fade_out)
	await tween.finished
	
	get_tree().paused = false
	if Engine.has_singleton("GF"):
		GF.load_scene(scene_path)
	else:
		get_tree().change_scene_to_file(scene_path)
