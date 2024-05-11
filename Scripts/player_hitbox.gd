extends Area2D

@export var healthcomponent: health_component

func damage(atk: attack):
	print("Damage func called!")
	healthcomponent.hp -= atk.damage
	if atk.stun_duration > 0:
		get_parent().stunned = true
		$stuntimer.wait_time = atk.stun_duration
		$stuntimer.start()
	if atk.facing_right == true:
		get_parent().velocity = atk.knockback
	else:
		get_parent().velocity = atk.knockback * Vector2(-1,1)
		


func _on_stuntimer_timeout():
	get_parent().stunned = false
