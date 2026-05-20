extends Node

#Ici on met en place les signaux que le robot devra écouter ou envoyer
#Passer par un event bus permet de réduire le couplage du code et donc de le rendre plus flexible

var request_id : int = 0

@warning_ignore_start("unused_signal")
#old
## @deprecated
signal pseudo_code_changed(pseudo_code : Array)

#Actions emitted by graph
signal move_right
signal move_left
signal jump_right
signal jump_left
signal check_obj_right
signal check_obj_left
signal check_obj_under
signal check_just_falled
#Triggers emitted by character
signal when_arrived
signal check_obj_right_response(id: int, response:bool)
signal check_obj_left_response(id: int, response:bool)
signal check_obj_under_response(id: int, response:bool)
signal check_just_falled_response(id: int, response:bool)

func get_unused_id() -> int:
	request_id = request_id+1
	return request_id-1
