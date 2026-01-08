extends Node2D

@onready var prompt_ui: Control = $UI
@onready var proximity_area: Area2D = $Proximity
@onready var interaction_window: Control = $UIWindow/InteractionWindow

var player_in_range := false
var window_open := false
var player: CharacterBody2D = null

func _ready():
	prompt_ui.visible = false
	interaction_window.visible = false

	proximity_area.body_entered.connect(_on_body_entered)
	proximity_area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is CharacterBody2D:
		player = body
		player_in_range = true
		if not window_open:
			prompt_ui.visible = true

func _on_body_exited(body):
	if body is CharacterBody2D:
		player_in_range = false
		prompt_ui.visible = false
		if window_open:
			close_window()
		player = null

func _unhandled_input(event):
	if player_in_range and not window_open and event.is_action_pressed("interact"):
		open_window()
		get_viewport().set_input_as_handled()

	elif window_open and event.is_action_pressed("ui_cancel"):
		close_window()
		get_viewport().set_input_as_handled()

func open_window():
	window_open = true
	prompt_ui.visible = false
	interaction_window.visible = true

	if player:
		player.set_physics_process(false)

func close_window():
	window_open = false
	interaction_window.visible = false

	if player_in_range:
		prompt_ui.visible = true

	if player:
		player.set_physics_process(true)
