extends Camera2D

var targets: Array = []
func _process(delta) -> void:
	targets.clear()
	print(global_position)
	get_targets()
	global_position = Vector2.ZERO
	for i in targets:
		global_position += i
	global_position /= targets.size()
	var target_distance = get_farthest_targets_dist()
	print(target_distance)
	#global_position = (target2.global_position + target1.global_position ) / 2
	if 0.3 / (target_distance / 4000) >= 0.75:
		zoom.x = 0.75
	else:
		zoom.x = 0.3 / (target_distance / 4000)
	zoom.y = zoom.x

func get_targets() -> void:
	for i:Node2D in get_tree().get_nodes_in_group("Trackable"):
		targets.append(i.global_position)

func get_farthest_targets_dist():
	var targets_distance: float = 0.0
	for x: Vector2 in targets:
		for y: Vector2 in targets:
			if x.distance_squared_to(y) > targets_distance:
				targets_distance = x.distance_squared_to(y)
	return sqrt(targets_distance)
