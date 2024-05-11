extends CharacterBody2D

#region Variables
@export var awaken_time: float = 20.0 ## Time Awaken lasts.
@export var awaken_damage_required: float = 200.0 ## Amount of damage required to awaken
var awakened: bool = false
var awaken_damage: float = 0.0
var awaken_particles: PackedScene = preload("res://Scenes/Particles/awaken.tscn")

@export var accel_speed: float = 3000.0 ## Speed that the character accelerates to max speed.
@export var max_speed: float = 1000.0 ## Maximum speed that the character can move at.
@export var friction: float = 4000.0 ## Speed that a player goes from moving to not moving.
@export var jump_vel: float = -800.0  ## How high the player can jump. Keep this negative, as up is negative in godot.
@export var gravity: float = 2500.0 ## How quickly the player returns to the ground.


@export var max_dash_speed: float = 3000.0 ## How fast the player is during the dash.
@export var dash_time: float = 0.25 ## How long a dash lasts in seconds.
@export var dash_cooldown_time: float = 0.2 ## How long it takes a dash to recharge in seconds.


var is_dashing: bool = false
var dash_cooled_down: bool = true
var can_dash: bool = true
var dash_dir: float = 0

var unique_id

var facing_right: bool = true
var stunned: bool = false : set = stunned_fx
func stunned_fx(val: bool):
	stunned = val
	if stunned == true:
		modulate = Color(1,0,0,1)
	else:
		modulate = Color(1,1,1,1)
#endregion

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(unique_id).to_int())
	set_multiplayer_authority(str(unique_id).to_int())
	$awakentime.wait_time = awaken_time
	$dashtimer.wait_time = dash_time
	$dashcooldown.wait_time = dash_cooldown_time
	
func _physics_process(delta):
	$hplabel.text = "HP: " + str($HealthComponent.hp)
	$awakenpercentlabel.text = "Awaken: " + str((awaken_damage/awaken_damage_required) * 100) + "%"
	if Input.is_action_just_pressed("Awaken") && awaken_damage >= awaken_damage_required \
		&& awakened ==false:
		print("AWAKEN!")
		awakened = true
		$awakentime.start()
		var particles: GPUParticles2D = awaken_particles.instantiate()
		particles.global_position = global_position
		particles.emitting = true
		particles.one_shot = true
		add_sibling(particles)
	
	
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if dash_cooled_down == true:
			can_dash = true
		# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_vel
		# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction < 0:
		facing_right = false
	elif direction > 0:
		facing_right = true
	if facing_right == true:
		$Attacks.rotation_degrees = 0
	else:
		$Attacks.rotation_degrees = 180
		
		
		
	if direction && stunned == false or is_dashing == true:
		if Input.is_action_just_pressed("Dash") && is_dashing == false && can_dash == true:
			is_dashing = true
			can_dash = false
			dash_cooled_down = false
			dash_dir = direction
			$dashtimer.start()
			velocity.x = max_dash_speed * dash_dir
		if is_dashing == true:
			dash(direction, delta)
		else:
			move(direction,delta)
	else:
		if is_on_floor() == true:
			velocity.x -= friction * sign(velocity.x) * delta
			if abs(velocity.x) <= friction * delta:
				velocity.x = 0
		else:
			velocity.x -= friction * sign(velocity.x) * delta * 0.5
			if abs(velocity.x) <= friction * delta:
				velocity.x = 0
	move_and_slide()




func move(direction: float, delta) -> void:
	if sign(direction) != sign(velocity.x):
		velocity.x += friction * direction * delta
	if abs(roundf(velocity.x)) < max_speed:
		velocity.x += accel_speed * direction * delta
	else:
		velocity.x = max_speed * sign(velocity.x)
	velocity.x = roundf(velocity.x)
func dash(direction, delta) -> void:
	velocity.x -= friction * sign(velocity.x) * delta * 0.1
	if abs(velocity.x) <= friction * delta:
		velocity.x = 0


func _on_dashtimer_timeout():
	$dashcooldown.start()
	is_dashing = false 


func _on_dashcooldown_timeout():
	dash_cooled_down = true


func _on_awakentime_timeout():
	awakened = false
	awaken_damage = 0
	print("Unawakened")
