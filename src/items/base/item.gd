## Base class for all items.
extends Resource
class_name Item

@export var name: String
@export var description: String
@export var icon: Texture2D
@export var is_placeable: bool = false
@export var quantity_data: QuantityComponent


## Effect application - item definition classes implement these
func _apply_effect(_actor: Player):
	pass

## Consumption handling
func _handle_consumption() -> bool:
	if not quantity_data:
		return true # Infinite/Permanent item
	
	# Usage logic
	if quantity_data.is_consumable:
		quantity_data.current_uses -= 1
		
		# Check if the single item is spent
		if quantity_data.current_uses <= 0:
			quantity_data.current_stack -= 1
			
			# Check if more stacks exist
			if quantity_data.current_stack > 0:
				# Reset the usage
				quantity_data.current_uses = quantity_data.max_uses
			else:
				# Item is completely used up
				return false
				
	return true # Item still exists

## Function called upon item usage
func use_item(actor: Player) -> bool:
	_apply_effect(actor)
	return _handle_consumption()
