extends Node2D

@export var spawn_1: Node2D
@export var spawn_2: Node2D

var playerscene: PackedScene = load("res://Scenes/Characters/template/template.tscn")

func _ready():
	var index = 0
	for i in Gamemanager.Players:
		var currentplayer: Node2D = playerscene.instantiate()
		currentplayer.unique_id = str(Gamemanager.Players[i].id)
		currentplayer.name = "C"+str(index)
		for spawn in get_tree().get_nodes_in_group("spawn"):
			if spawn.name == str(index):
				currentplayer.global_position = spawn.global_position
		add_child(currentplayer)
		index += 1
	print("Done!")
