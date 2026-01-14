# Item - root abstract class for items
extends Resource
class_name Item

@export_category("Basic Info")
@export var id: String
@export var name: String
@export var description: String
@export var icon: Texture2D

@export_category("Components")
@export var stackable: StackableComponent
@export var equippable: EquippableComponent

# Optional: Item categories via enum
enum ItemType { CONSUMABLE, WEAPON, ARMOR, MISC }
@export var item_type = ItemType.MISC

func use(_user) -> bool:
	push_warning("[WARNING] Base Item.use() called - override in subclass")
	return false

func get_description() -> String:
	return description
