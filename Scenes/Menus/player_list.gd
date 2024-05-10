extends Panel

const PlayerLable = preload("res://Scenes/Menus/PlayerLable.tscn")
var spacing = 0

func _on_timer_timeout():
	spacing = 0
	for i in $ItemList.get_children():
		i.queue_free()
	for player in Gamemanager.Players:
		var child = PlayerLable.instantiate()
		child.text = str(Gamemanager.Players[player].Username)
		child.global_position.y += spacing
		child.z_index = 100
		$ItemList.add_child(child)
		spacing += 40
