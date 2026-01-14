extends Node

var player: CharacterBody2D
var broom: Node2D
var broom_sprite: Sprite2D
var floating_effect: Node
var broom_enabled := false

func _ready() -> void:
	player = get_parent() as CharacterBody2D

	# Broom je direktni child Playerja
	broom = player.get_node_or_null("Broom")
	if broom:
		broom_sprite = broom.get_node_or_null("Sprite2D")
		broom.visible = false
	else:
		print("❌ Broom not found")

	# FloatingEffect je tudi child Playerja
	floating_effect = player.get_node_or_null("FloatingEffect")
	if floating_effect:
		floating_effect.set_process(false)
	else:
		print("❌ FloatingEffect not found")

	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("broom_use"):
		broom_enabled = !broom_enabled
		_apply_state()

func _apply_state() -> void:
	if broom:
		broom.visible = broom_enabled

		# Metlo malo odmakni, da se vidi
		broom.position = Vector2(12, -4)

		# Flip metle glede na player sprite
		var player_sprite: Sprite2D = player.get_node("Sprite2D")
		if broom_sprite:
			broom_sprite.flip_h = player_sprite.flip_h

	if floating_effect:
		floating_effect.set_process(broom_enabled)
