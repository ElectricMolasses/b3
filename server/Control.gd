extends Node

signal player_added(pid)
signal player_removed(pid)

signal player_joined_room(pinfo)
signal player_left_room(pinfo)

var server_info = {
	name = "Main",
		max_players = 256,
		used_port = 4587
}

var players = {}
var games = {}
var room_list = {}

var gameTemplate = preload("res://Game.tscn")

func _ready():
	get_tree().connect("network_peer_connected", self, "_on_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")

	create_server()
	create_game("Main Room")
	create_game("Test 1")
	create_game("Test 2")

func _on_player_connected(id):
	players[id] = "NA"
	rpc_id(id, "update_lobby", room_list)

func _on_player_disconnected(id):
	if (players[id] != "NA"):
		games[players[id]]._player_removed(id)
	players.erase(id)

func create_server():
	# Initialize network
	var net = NetworkedMultiplayerENet.new()

	# Attempt to launch server
	if (net.create_server(server_info.used_port, server_info.max_players) != OK):
		print("Failed to create server")
		return

	get_tree().set_network_peer(net)

# Created a game node and sets the name to desired name.
func create_game(name):
	var newGame = gameTemplate.instance()
	newGame.name = name
	games[name] = newGame
	room_list[name] = {
		'players': 0,
		'max_players': 64
	}
	self.add_child(newGame)

remote func player_joined_room(room_name):
	var player = get_tree().get_rpc_sender_id()
	players[player] = room_name
	if games.has(room_name):
		print(room_name)
		rpc_id(player, "join_game_success", room_name)
		games[room_name]._player_added(player)

remote func request_lobby_update():
	var player_id = get_tree().get_rpc_sender_id()
	
	rpc_id(player_id, "update_lobby", room_list)























































