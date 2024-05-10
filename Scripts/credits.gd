extends Control



func _on_back_pressed():
	hide()
	for i in get_parent().get_children():
		i.show()
	hide()
