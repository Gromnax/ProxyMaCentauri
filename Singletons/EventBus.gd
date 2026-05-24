extends Node

#Ici on met en place les signaux que le robot devra écouter ou envoyer
#Passer par un event bus permet de réduire le couplage du code et donc de le rendre plus flexible

## Id de requête pour retour
static var request_id : int = 0

@warning_ignore_start("unused_signal")
# Actions emitted by graph
signal move_right(id:int)
signal move_left(id:int)
signal jump_right(id:int)
signal jump_left(id:int)
signal check_obj(id:int, direction: Vector2i)
signal check_just_fell(id:int)
# Triggers emitted by character
signal check_is_arrived(id:int, response:bool)
signal check_obj_response(id:int, response:bool)
signal check_just_fell_response(id:int, response:bool)

signal level_start()

func get_unused_id() -> int:
	request_id = request_id+1
	return request_id-1

func _init() -> void:
	move_right.connect(log_signal.bind(false, "move_right"))
	move_left.connect(log_signal.bind(false, "move_left"))
	jump_right.connect(log_signal.bind(false, "jump_right"))
	jump_left.connect(log_signal.bind(false, "jump_left"))
	check_obj.connect(log_signal.bind(false, "check_obj_right"))
	check_just_fell.connect(log_signal.bind(false, "check_just_fell"))
	check_is_arrived.connect(log_signal.bind("check_is_arrived"))
	check_obj_response.connect(log_signal.bind("check_obj_right_response"))
	check_just_fell_response.connect(log_signal.bind("check_just_fell_response"))
	
func log_signal(id: int, _response: bool = false, signal_name: String="") -> void:
	var to_print : String = ""
	to_print += "Signal called ("+str(id)+") : "
	to_print += signal_name
	print(to_print)
