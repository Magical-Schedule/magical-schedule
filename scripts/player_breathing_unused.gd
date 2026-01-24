extends Node

#@export var speed := 11.0
#@export var strength := 0.03

#var time := 0.0
#var sprite: Sprite2D
#var base_scale: Vector2
#var player: CharacterBody2D  

#func _ready() -> void:
	#sprite = get_parent().get_node("Sprite2D")
	#base_scale = sprite.scale
	#player = get_parent() as CharacterBody2D  # pridobi player-ja

# resetiraj na osnovno velikost
#func _process(delta: float) -> void:
	#if player and player.velocity.length() > 1.0:
		#sprite.scale = base_scale 
		#return
		
	#time += delta * speed
	#var s := 1.0 + sin(time) * strength
	#sprite.scale = base_scale * s
