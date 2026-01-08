extends Label

var start_pos: Vector2

@export var float_distance := 6.0
@export var float_time := 1.5

func _ready():
	start_floating()

func start_floating():
	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(self, "position:y", start_pos.y + float_distance, float_time)
	tween.tween_property(self, "position:y", start_pos.y - float_distance, float_time)
