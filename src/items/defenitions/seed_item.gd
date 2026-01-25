## Base class for all seed.
extends Item
class_name SeedItem

@export var yield_item: YieldItem # The .tres of the fruit/flower
@export var growth_time: float = 10.0

## func _apply_effect(actor: Player):
	# Here, you'd call your world-manager to place a plant
	# that eventually gives the 'yield_item'
	## WorldManager.spawn_plant(actor.global_position, self)
