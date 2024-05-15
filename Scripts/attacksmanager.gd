extends Node2D
class_name attacks_manager ## Manages attacks and everything related to them.

@export var l_attack_man: attackmanager
@export var h0_attack_man: attackmanager

@export var h1_attack_man: attackmanager
@export var h2_attack_man: attackmanager
@export var h3_attack_man: attackmanager
@export var h4_attack_man: attackmanager

@export var ah0_attack_man: attackmanager
@export var ah1_attack_man: attackmanager
@export var ah2_attack_man: attackmanager
@export var ah3_attack_man: attackmanager
@export var ah4_attack_man: attackmanager
var is_attacking: bool = false

func _ready():
	set_multiplayer_authority(str(get_parent().unique_id).to_int())

func _physics_process(delta):
	if multiplayer.multiplayer_peer != null:
		if multiplayer.get_unique_id() != get_multiplayer_authority():
			return
	if l_attack_man.attacking == true:
		#get_parent().velocity.x -= 5000 * delta
		#get_parent().velocity.y -= 5000 * delta
		return
	if h0_attack_man.attacking == true:
		return
	if get_parent().awakened == false:
		normal_inputs()
	else:
		awakened_inputs()

func normal_inputs():
	if Input.is_action_just_pressed("LightAttack"):
		l_attack_man.start_attack()
		$"../Sprite2D".play("light")
	if Input.is_action_just_pressed("Heavy0") && h0_attack_man.ready_to_attack == true:
		h0_attack_man.start_attack()
		$"../Sprite2D".play("h0")
	if Input.is_action_just_pressed("Heavy1") && h1_attack_man.ready_to_attack == true:
		h1_attack_man.start_attack()
		$"../Sprite2D".play("h1")
	if Input.is_action_just_pressed("Heavy2") && h2_attack_man.ready_to_attack == true:
		h2_attack_man.start_attack()
		$"../Sprite2D".play("h2")
	if Input.is_action_just_pressed("Heavy3") && h3_attack_man.ready_to_attack == true:
		h3_attack_man.start_attack()
		$"../Sprite2D".play("h3")
	if Input.is_action_just_pressed("Heavy4") && h4_attack_man.ready_to_attack == true:
		h4_attack_man.start_attack()
		$"../Sprite2D".play("h4")

func awakened_inputs():
	if Input.is_action_just_pressed("LightAttack"):
		l_attack_man.start_attack()
		$"../Sprite2D".play("alight")
	if Input.is_action_just_pressed("Heavy0") && ah0_attack_man.ready_to_attack == true:
		ah0_attack_man.start_attack()
	if Input.is_action_just_pressed("Heavy1") && ah1_attack_man.ready_to_attack == true:
		ah1_attack_man.start_attack()
	if Input.is_action_just_pressed("Heavy2") && ah2_attack_man.ready_to_attack == true:
		ah2_attack_man.start_attack()
	if Input.is_action_just_pressed("Heavy3") && ah3_attack_man.ready_to_attack == true:
		ah3_attack_man.start_attack()
	if Input.is_action_just_pressed("Heavy4") && ah4_attack_man.ready_to_attack == true:
		ah4_attack_man.start_attack()

func end_dash():
	$"../dashcooldown".start()
	get_parent().is_dashing = false 
