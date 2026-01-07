class_name Player
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D

var move_speed: float = 350.0

var breathe_time: float = 0.0
var breathe_speed: float = 2.0
var breathe_amount: float = 0.03

var base_scale: Vector2

func _ready() -> void:
	base_scale = sprite.scale

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	direction = direction.normalized()
	velocity = move_speed * direction


	if direction.x != 0:
		sprite.flip_h = direction.x > 0

	var target_speed = breathe_speed if velocity.length() < 1.0 else breathe_speed * 1.5
	breathe_time += delta * target_speed

	if velocity.length() < 1.0:
		var scale_offset := sin(breathe_time) * breathe_amount
		sprite.scale = base_scale * (1.0 + scale_offset)
	else:
		sprite.scale = base_scale

	move_and_slide()
