extends VBoxContainer

@export var fade_time := 0.5

func _ready():
	await get_tree().process_frame
	modulate.a = 0.0
	await get_tree().process_frame
	await get_tree().create_timer(2.0).timeout
	fade_in()
	

func fade_in():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "modulate:a", 1.0, fade_time)

func _process(delta: float) -> void:
	pass
