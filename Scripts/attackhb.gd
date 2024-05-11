extends Area2D
class_name attackhb
#Attack Hitbox
@export var damage: float = 20.0 ## The amount of damage the recipient takes opun succesful hit.
@export var attack_duration: float = 0.1 ## How long the hitbox stays attacking in seconds.
@export var knockback: Vector2 = Vector2(0.0,0.0) ## Amount of knockback the attack gives the recipient.
@export var stun_duration: float = 0.1 ## Amount of time recipient cannot move or fight back in seconds.
@export var cooldown_duration: float = 0.05 ## Amount of time it takes to be able to use a move again.
@export var attack_startup_duration: float = 0.0 ## Amount of time before attack happens after the player clicks.
@export var move_speed_multiplier: float = 1.0 ## Amount that speed will be multiplied during the attack. Speed multiplier applies during attack windup.


@export var auto_transition: bool = true ## Automatically starts the attack in the attack transition variable. If off, the next attack will trigger after the player presses the same key to use this move again.
@export var attack_transition: attackhb ## The next hitbox in the chain of attacks.

@onready var character: Node2D = get_parent().get_parent().get_parent()

signal attack_complete

func _ready():
	$ATKtimer.wait_time = attack_duration
	$CDtimer.wait_time = cooldown_duration
	$windup.wait_time = attack_startup_duration
@rpc("any_peer","call_local")
func atk():
	if attack_startup_duration ==0:
		show()
		$ATKtimer.start()
	else:
		monitorable = false
		monitoring = false
		character.modulate = Color(0.5,0.5,0,1)
		$windup.start()


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("damage"):
		var atk = attack.new()
		atk.damage = damage
		atk.knockback = knockback
		atk.stun_duration = stun_duration
		if get_parent().get_parent().rotation_degrees == 0:
			atk.facing_right = true
		else:
			atk.facing_right = false
		area.damage(atk)
		character.awaken_damage += damage


func _on_timer_timeout():
	$CDtimer.start()
	monitorable = false
	monitoring = false
	hide()


func _on_cdtimer_timeout():
	attack_complete.emit(attack_transition, auto_transition)


func _on_windup_timeout():
	get_parent().get_parent().get_parent().modulate = Color(1,1,1,1)
	monitorable = true
	monitoring = true
	show()
	$ATKtimer.start()
