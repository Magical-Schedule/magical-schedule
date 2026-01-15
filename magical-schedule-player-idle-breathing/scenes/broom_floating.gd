extends Node2D

@export var float_speed: float = 2.0
@export var float_amount: float = 6.0

var time := 0.0
var player: CharacterBody2D
var sprite: Sprite2D
var camera: Camera2D
var broom: Node2D
var broom_sprite: Sprite2D
var sprite_base_y: float
var camera_base_y: float
var broom_base_y: float
var broom_use: Node

func _ready() -> void:
	player = get_parent() as CharacterBody2D

	if player:
		sprite = player.get_node_or_null("Sprite2D")
		if sprite:
			sprite_base_y = sprite.position.y

		camera = player.get_node_or_null("Camera2D")
		if camera:
			camera_base_y = camera.position.y

		broom = player.get_node_or_null("Broom")
		if broom:
			broom_base_y = broom.position.y
			broom_sprite = broom.get_node_or_null("Sprite2D")

		# najdi BroomUse skripto
		broom_use = player.get_node_or_null("BroomUse")

func _process(delta: float) -> void:
	if not player:
		return

	#Flip metle vedno sinhroniziraj s playerjem
	if sprite and broom_sprite:
		broom_sprite.flip_h = sprite.flip_h

	#Če metla NI aktivna → nič ne lebdi
	if broom_use and not broom_use.broom_enabled:
		if sprite:
			sprite.position.y = sprite_base_y
		if camera:
			camera.position.y = camera_base_y
		if broom:
			broom.position.y = broom_base_y
		return

	#Če se player premika nič ne lebdi
	if player.velocity.length() > 1.0:
		if sprite:
			sprite.position.y = sprite_base_y
		if camera:
			camera.position.y = camera_base_y
		if broom:
			broom.position.y = broom_base_y
		time = 0.0
		return

	#Lebdenje samo ko stoji in ima metlo
	time += delta * float_speed
	var offset = sin(time) * float_amount

	if sprite:
		sprite.position.y = sprite_base_y + offset
	if camera:
		camera.position.y = camera_base_y + offset
	if broom:
		broom.position.y = broom_base_y + offset
