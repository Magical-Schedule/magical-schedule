extends Control

@onready var click := $ClickSound
@export var fade := 0.35
@onready var confirmReset := $ConfirmReset

@onready var masterVolLabel: RichTextLabel = get_node("VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/MasterVolLabel") as RichTextLabel
@onready var masterVolSlider: HSlider = get_node("VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/MasterVolSlider") as HSlider


func _ready() -> void:
	modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, fade)
	load_settings()


func _process(delta: float) -> void:
	pass


func load_settings() -> void:
	var saved_value = Settings.get_setting("audio/master_volume")
	masterVolSlider.value = saved_value
	_on_master_vol_slider_value_changed(saved_value)

func _input(event):
	if event.is_action_pressed("pause"):
		close_menu()


func close_menu() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, fade)
	
	await tween.finished
	queue_free()


func _on_back_pressed() -> void:
	close_menu()


func _on_any_button_pressed():
	click.play()


func _on_master_vol_slider_value_changed(value: float) -> void:
	masterVolLabel.clear()
	masterVolLabel.add_text("Master Volume: %d%%" % int(value))
	Settings.set_setting("audio/master_volume", value)


func _on_reset_pressed() -> void:
	confirmReset.popup_centered()

func _on_confirm_reset_confirmed() -> void:
	Settings.reset_to_defaults()
	load_settings()


func _on_confirm_reset_canceled() -> void:
	pass
