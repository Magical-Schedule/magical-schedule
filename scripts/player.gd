class_name Player
extends CharacterBody2D

var move_speed: float = 350.0

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	direction = direction.normalized()

	velocity = move_speed * direction
	move_and_slide()
