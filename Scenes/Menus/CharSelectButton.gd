extends Button
@export var character_id: int = 0 ## The ID of the character. Check character Schema for IDs.



func _on_pressed():
	Gamemanager.set_character(multiplayer.get_unique_id(), character_id)
	
func set_character():
	pass
