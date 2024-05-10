extends Control

var MainMenu = load("res://Scenes/Menus/MainMenu.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_packed(MainMenu)


func _on_unpause_pressed():
	hide()
	get_tree().paused = false
