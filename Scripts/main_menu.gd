extends Control
var testscene: PackedScene = load("res://Scenes/Menus/CharacterSelectOffline.tscn")
var multiplayerscene: PackedScene = load("res://Scenes/Menus/Multiplayer.tscn")

func _on_play_local_pressed():
	print("CBT")
	get_tree().change_scene_to_packed(testscene)


func _on_play_online_pressed():
	get_tree().change_scene_to_packed(multiplayerscene)


func _on_credits_pressed():
	#get_tree().change_scene_to_packed(credits)
	for i in get_children():
		i.hide()
	$Credit.show()


func _on_quit_pressed():
	get_tree().quit()
