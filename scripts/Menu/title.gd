extends Label

@export var wait := 1.0

func _ready() -> void:
	flicker()

func _process(delta):
	pass

func flicker():
	while true:
		modulate.a = 1.0
		await get_tree().create_timer(wait).timeout
		modulate.a = 0.0
		await get_tree().create_timer(wait).timeout
