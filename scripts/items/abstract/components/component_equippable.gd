# StackableComponent - component for stackable items
class_name EquippableComponent extends Resource

@export_enum("Hand", "Body", "Head", "Cyberware") var slot: String = ""
@export var stat_bonuses: Dictionary = {}
