extends Node2D
class_name attackmanager
var attacks: Array

@export var first_attack: attackhb ## Set this to the first hitbox in the attack.
@export var cleartime: float = 1.0 ## If attack transitions are not set to automatic, if you do not attack within this time frame, it will reset back to attack 1.
@export var full_cd_duration: float = 5.0 ## Duration that this move cannot be used. Other moves may be used.

var current_attack: attackhb
var ready_to_attack: bool = true
var attacking: bool = false

func _ready():
	attacks = get_children()
	current_attack = first_attack
	$cleartimer.wait_time = cleartime
	$cooldown.wait_time = full_cd_duration

func start_attack():
	$cleartimer.stop()
	$cleartimer.start()
	current_attack.monitoring = true
	current_attack.monitorable = true
	current_attack.atk()
	attacking = true
func _on__attack_complete(attack_transition, auto_transition):
	if attack_transition != null:
		current_attack = attack_transition
		if attack_transition.auto_transition == true:
			start_attack()
	else:
		current_attack = first_attack
		if full_cd_duration != 0:
			ready_to_attack = false
			$cooldown.start()
	attacking = false

func clear():
	current_attack = first_attack
	attacking = false


func _on_cleartimer_timeout():
	clear()


func _on_cooldown_timeout():
	ready_to_attack = true
