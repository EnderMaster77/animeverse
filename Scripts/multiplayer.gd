extends Control
@export var Address = "127.0.0.1"
@export var port = 8910
var mainmenu = load("res://Scenes/Menus/MainMenu.tscn")
var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.server_relay = true
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	if "--server" in OS.get_cmdline_args():
		hostGame()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# this get called on the server and clients
func peer_connected(id):
	print("Player Connected " + str(id))
	
# this get called on the server and clients

func peer_disconnected(id):
	print(Gamemanager.Players)	
	print("Player Disconnected " + str(id))
	Gamemanager.Players.erase(id)
	for i in get_tree().get_nodes_in_group("Player"):
		if i.unique_id == str(id):
			i.queue_free()
			break
	if Gamemanager.Players.size() <= 1:
		Gamemanager.clear()
		get_tree().change_scene_to_packed(mainmenu)
# called only from clients
func connected_to_server():
	print("connected To Sever!")
	SendPlayerInfo.rpc( $PreMenu/LineEdit2.text, multiplayer.get_unique_id())

# called only from clients
func connection_failed():
	print("Couldnt Connect")

@rpc("any_peer")
func SendPlayerInfo(Username, id):
	if !Gamemanager.Players.has(id):
		Gamemanager.Players[id]={
			"Username": Username,
			"id":id,
		}
	if multiplayer.is_server():
		for i in Gamemanager.Players:
			SendPlayerInfo.rpc(Gamemanager.Players[i].Username, i)

@rpc("any_peer","call_local")
func StartGame():
	var scene = load("res://Scenes/Stages/TestStage.tscn").instantiate()
	# get_tree().root.add_child(scene) 
	# The worst line of code in this entire fucking game.
	# This line is costing me hours because of how shittily it integrates with
	# the rest of godot, causing VITAL FUNCTIONS like change_scene_to_packed()
	# to behave unexpectedly. Fuck this line of code, and curse the guy making the
	# tutorial.
	add_child(scene)
	hide_all()
func hostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print("Cannot host: ",error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players!")


func _on_host_pressed():
	Gamemanager.Players = {}
	hostGame()
	SendPlayerInfo($PreMenu/LineEdit2.text, multiplayer.get_unique_id())
	hide_all()
	$HostMenu.show()


func _on_join_pressed():
	hide_all()
	$JoinMenu.show()
	show_join()

func _on_back_pressed():
	Gamemanager.Players = { 1: { "Username": "Host", "id": 1 } }
	get_tree().change_scene_to_packed(mainmenu)

func hide_all():
	$Host.hide()
	$Back.hide()
	$Join.hide()
	$Label.hide()
	$HostMenu.hide()
	$PreMenu.hide()
	$JoinMenu.hide()
	$JoinedMenu.hide()
func show_all():
	for i in get_children():
		i.show()



func _on_child_back_pressed():
	show_all()
	$JoinMenu.hide()
	$HostMenu.hide()
	$JoinedMenu.hide()
	$PreMenu.hide()

func _on_join_game_pressed():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	show_join()
	$JoinedMenu.show()
	$PreMenu.hide()
	$JoinMenu.hide()

func show_join():
	$PreMenu.show()
	$PreMenu/Label.hide()
	$PreMenu/Host.hide()

func show_host():
	for child in $PreMenu.get_children():
		child.show()
	$PreMenu.show()

func _on_disconnect_pressed():
	show_all()
	$JoinMenu.hide()
	$HostMenu.hide()
	$JoinedMenu.hide()
	$PreMenu.hide()
	

func _on_start_pressed():
	StartGame.rpc()


func _on_hostmenu_pressed():
	hide_all()
	show_host()
