extends Sprite2D

@export var breath_speed := 2.0
@export var strength := 0.04

var time := 0.0
var start_scale: Vector2

func _ready():
	start_scale = scale

func _process(delta):
	time += delta * breath_speed
	var s = 1.0 + sin(time) * strength
	scale = start_scale * s
