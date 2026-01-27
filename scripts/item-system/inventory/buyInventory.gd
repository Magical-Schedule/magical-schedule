extends Control

@onready var box = $PanelContainer/HBoxContainer
var inUi

func setup_buy_button(node_path: String, item_name: String):
	var button = box.get_node(node_path)
	if not button:
		push_error("Could not load button: " + button)
	
	# Construct the path dynamically based on your folder structure
	var path = "res://data/items/seeds/" + item_name + ".tres"
	var item = load(path) as Item
	if not item:
		push_error("Could not load item resource at: " + path)
	
	button.texture_normal = item.icon
	button.pressed.connect(_on_buy_clicked.bind(item_name))

func _ready():
	setup_buy_button("TextureButton", "seed_grass")
	setup_buy_button("TextureButton2", "seed_mushroom")
	setup_buy_button("TextureButton3", "seed_flower")
	setup_buy_button("TextureButton4", "seed_flytrap")
	setup_buy_button("TextureButton5", "seed_tree")

func _on_buy_clicked(item_name: String):
	var play = get_tree().root.find_child("Playground", true, false)
	inUi =  get_tree().root.find_child("InventoryUi", true, false)
	var path = "res://data/items/seeds/" + item_name + ".tres"
	var item: Item = load(path)
	
	if item.price <= play.get_money():
		play.modify_balance(-item.price)
	else: return
	
	if item:
		inUi.add_item(item)
