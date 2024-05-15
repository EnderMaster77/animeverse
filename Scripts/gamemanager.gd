extends Node

var Players = { 1: { "Username": "Host", "id": 1, "characterid": 0 } }

func clear(): ## Clears all server multiplayer components.
	Players = { multiplayer.get_unique_id(): { "Username": "Host", "id": multiplayer.get_unique_id(), "characterid": 0 } }
	multiplayer.multiplayer_peer = null

func set_character(id:int, characterid:int):
	Players[id]["characterid"] = characterid
	print(Players[id]["characterid"])
	
