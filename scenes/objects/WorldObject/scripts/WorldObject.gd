extends Node2D

@onready var ui: Control = $UI
@onready var proximity_area: Area2D = $Proximity

func _ready():
	ui.visible = false
	proximity_area.body_entered.connect(_on_body_entered)
	proximity_area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is CharacterBody2D:
		ui.visible = true

func _on_body_exited(body):
	if body is CharacterBody2D:
		ui.visible = false
