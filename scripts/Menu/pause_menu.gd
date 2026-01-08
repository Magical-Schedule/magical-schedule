extends "res://scripts/Menu/menu.gd"

var menuScene : String = "res://scenes/Menu/MainMenu.tscn"

@export var fade := 0.25
var is_open := false
@onready var toMenuConfirm := $ToMenu
@onready var toDesktopConfirm := $ToDesktop

func _ready():
	visible = false
	modulate.a = 0.0
	set_process_input(true)
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

#Pomembno: Eden izmed starševskih nodov mora imeti skripto ki registrira pause menu, in ob
#pritisku na ESC pokliče .open_menu (glej playground.gd)
#Inputi drugače ne pridejo do pause menu, ko je izklopljen.
func _input(event):
	if event.is_action_pressed("pause"):
		print("paused")
		if is_open:
			close_menu()
		else:
			open_menu()

func open_menu():
	is_open = true
	visible = true
	get_tree().paused = true
	
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, fade)

func close_menu():
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, fade)
	
	await tween.finished
	
	visible = false
	get_tree().paused = false
	is_open = false


func _on_quit_to_menu_pressed() -> void:
	toMenuConfirm.popup_centered()


func _on_quit_to_desktop_pressed() -> void:
	toDesktopConfirm.popup_centered()


func _on_continue_pressed() -> void:
	close_menu()


func _on_to_menu_canceled() -> void:
	pass


func _on_to_menu_confirmed() -> void:
	fade_then_load_scene(menuScene)


func _on_to_desktop_canceled() -> void:
	pass


func _on_to_desktop_confirmed() -> void:
	quit()
