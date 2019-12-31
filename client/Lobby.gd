extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var game = preload("res://Game.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_node("..").join_game(GameState.room_info.name)	
	# Give a joining popup here if necceary, swap scene once the server says it's okay to.
	
# This will be called if Core.join_game succeeded.
func room_join_success(room_info):
	var room = game.instance()
	room.name = room_info.name
	get_node("..").swap_scene(get_node("."), room)
# This will be called if Core.join_game failed.