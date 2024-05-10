extends CharacterBody2D


@export var gravity: float = 2500
@export var accel_speed: float = 3000
@export var max_speed: float = 1000
@export var friction: float = 4000
@export var jump_vel: float = -800.0

var stunned: bool = false

func _physics_process(delta):
	if $HealthComponent.hp <= 0:
		$HealthComponent.hp = 100
	$Label.text="HP: " + str($HealthComponent.hp)
	if stunned == true:
		modulate = Color(1,0,0,1)
	else:
		modulate = Color(1,1,1,1)
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.x -= friction * sign(velocity.x) * delta * 0.25
		if abs(velocity.x) <= friction * delta:
			velocity.x = 0
	else:
		velocity.x -= friction * sign(velocity.x) * delta
		if abs(velocity.x) <= friction * delta:
			velocity.x = 0
	move_and_slide()
