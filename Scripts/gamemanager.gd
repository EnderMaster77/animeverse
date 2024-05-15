extends Node

var Players = { 1: { "Username": "Host", "id": 1, "score": 0 } }

func clear(): ## Clears all server multiplayer components.
	Players = { multiplayer.get_unique_id(): { "Username": "Host", "id": multiplayer.get_unique_id(), "score": 0 } }
	multiplayer.multiplayer_peer = null
