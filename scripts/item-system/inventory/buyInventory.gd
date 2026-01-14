extends Control

@onready var box = $PanelContainer/HBoxContainer
var inUi 
func _ready():
	box.get_node("TextureButton").pressed.connect(_on_buy_clicked.bind("blue_flower_seed"))
	box.get_node("TextureButton2").pressed.connect(_on_buy_clicked.bind("red_flower_seed"))
	box.get_node("TextureButton3").pressed.connect(_on_buy_clicked.bind("yellow_flower_seed"))
	box.get_node("TextureButton4").pressed.connect(_on_buy_clicked.bind("green_flower_seed"))
	box.get_node("TextureButton5").pressed.connect(_on_buy_clicked.bind("white_flower_seed"))

func _on_buy_clicked(item_name: String):
	inUi =  get_tree().root.find_child("InventoryUi", true, false)
	var path = "res://scripts/items/Define/" + item_name + ".tres"
	var item = load(path)
	if item:
		inUi.add_item(item)
