extends Node

@onready var player: CharacterBody2D = get_parent()
@onready var broom_use: Node = null

var float_amplitude: float = 8.0  
var float_speed: float = 2.0  
var original_y: float = 0.0
var time: float = 0.0
var is_floating: bool = false

func _ready():
	broom_use = player.get_node_or_null("BroomUse")
	if not broom_use:
		push_error("BroomUse node ni najden!")
		return
	
	original_y = player.position.y
	print("✓ BroomFloating ready!")

func _process(delta):
	if not broom_use:
		return
	
	var broom_enabled = broom_use.broom_enabled
	var is_moving = player.velocity.length() > 10.0
	
	if broom_enabled and not is_moving:
		if not is_floating:
			original_y = player.position.y
			is_floating = true
			time = 0.0
		
		time += delta * float_speed
		var offset = sin(time) * float_amplitude
		player.position.y = original_y + offset
	else:
		if is_floating:
			player.position.y = original_y
			is_floating = false
			time = 0.0
