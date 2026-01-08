extends Control

@export var slide_time := 0.5
@export var fade_time := 0.5
@export var offscreen_offset := Vector2(-700, 0)

var start_pos: Vector2

@export var float_distance := 10.0
@export var float_time := 1.5

func _ready():
	start_pos = position
	position += offscreen_offset
	await get_tree().process_frame
	modulate.a = 0.0
	await get_tree().process_frame
	await get_tree().create_timer(2.0).timeout
	fade_in()
	slide_in()
	start_floating()

func fade_in():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "modulate:a", 1.0, fade_time)

func slide_in():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "position", start_pos, slide_time)
	

func start_floating():
	var tween = create_tween()
	tween.set_loops()  # infinite loop
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(self, "position:y", start_pos.y - float_distance, float_time)
	tween.tween_property(self, "position:y", start_pos.y + float_distance, float_time)
