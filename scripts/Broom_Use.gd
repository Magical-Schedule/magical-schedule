extends Node
@onready var broom: Node2D = get_parent().get_node_or_null("Broom")
@onready var broom_sprite: Sprite2D = broom.get_node_or_null("Sprite2D")
@onready var player_sprite: AnimatedSprite2D = get_parent().get_node_or_null("AnimatedSprite2D")
var broom_enabled := false
var last_horizontal_flip := true  

func _ready():
	if not broom:
		push_error("Broom node ni najden!")
		return
	
	broom.visible = false
	broom_enabled = false
	if player_sprite:
		last_horizontal_flip = player_sprite.flip_h

func _unhandled_input(event):
	if not broom:
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_Z:
		toggle_broom()
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("broom_use"):
		toggle_broom()
		get_viewport().set_input_as_handled()

func toggle_broom():
	broom_enabled = not broom_enabled
	broom.visible = broom_enabled

func _process(_delta):
	if broom_enabled and broom_sprite and player_sprite:
		if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_D):
			last_horizontal_flip = player_sprite.flip_h
		broom_sprite.flip_h = not last_horizontal_flip
