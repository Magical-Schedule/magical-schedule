## Component for stacking and usage.
extends Resource
class_name QuantityComponent

@export var max_stack: int = 1
@export var max_uses: int = 1
@export var is_consumable: bool = true

## Instance variables
var current_stack: int = 1
var current_uses: int = 1

func initialize():
	current_uses = max_uses
