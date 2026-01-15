extends Control

@onready var box = $PanelContainer/HBoxContainer
var inUi 
func _ready():
	box.get_node("TextureButton").pressed.connect(_on_buy_clicked.bind("blue_flower_seed"))
	box.get_node("TextureButton2").pressed.connect(_on_buy_clicked.bind("mushroom_seed"))
	box.get_node("TextureButton3").pressed.connect(_on_buy_clicked.bind("fly_seed"))
	box.get_node("TextureButton4").pressed.connect(_on_buy_clicked.bind("grass_seed"))
	box.get_node("TextureButton5").pressed.connect(_on_buy_clicked.bind("tree_seed"))


func _on_buy_clicked(item_name: String):
	var play = get_tree().root.find_child("Playground", true, false)
	inUi =  get_tree().root.find_child("InventoryUi", true, false)
	var path = "res://scripts/items/Define/" + item_name + ".tres"
	var item = load(path)
	if item.price <=play.get_money():
		play.sub_money(item.price)
	else:
		return
	if item:
		inUi.add_item(item)
