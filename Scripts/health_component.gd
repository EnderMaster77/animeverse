extends Node2D
class_name health_component

@export var max_hp: float = 100.0
@export var hp: float = 100.0
@export var start_with_max_hp: bool = true

func _ready():
	if start_with_max_hp == true:
		hp = max_hp

func _process(delta):
	if hp <= 0:
		print("die ", get_parent())
