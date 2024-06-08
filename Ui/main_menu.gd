extends Control

signal start_game()
@onready  var button_container = $"MarginContainer/VBoxContainer/Button Container"

func _ready():
	focus_button()
	pass

func _process(delta):
	pass
	
func _on_start_game_pressed():
	start_game.emit()
	get_tree().change_scene_to_file("res://Scenes/Levels/lv_1.tscn")
	hide()
	pass	
	
func _on_options_pressed():
	pass 

func _on_exit_pressed():
	get_tree().quit()


func _on_button_container_visibility_changed():
	if visible:
		focus_button()
	pass # Replace with function body.

func focus_button():
	if button_container:
		var button : Button = button_container.get_child(0)
		if button is Button:
			button.grab_focus()
	pass
