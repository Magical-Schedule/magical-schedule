extends Resource
class_name ItemData

@export var name: String = "New Item"
@export var stackable: bool = true
@export var icon: Texture2D
@export var placable: bool
@export var plantable: bool
@export var price: int = 10
@export var is_seed: bool = false
@export var crop_row_index: int = 0
@export var growth_spritesheet: Texture2D
