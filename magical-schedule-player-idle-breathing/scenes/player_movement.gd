extends Node
#
#@export var speed: float = 350.0
#var player: CharacterBody2D
#var sprite: Sprite2D
#
#func _ready() -> void:
	#player = get_parent() as CharacterBody2D
	#if player:
		#sprite = player.get_node_or_null("Sprite2D")
#
#func _physics_process(_delta: float) -> void:  
	#if not player:
		#return
	#
	#var direction := Vector2.ZERO
	#direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	#direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	#direction = direction.normalized()
	#
	#player.velocity = direction * speed
	#player.move_and_slide()
	#
	#if sprite and direction.x != 0:
		#sprite.flip_h = direction.x > 0
