extends Node

#Ici on met en place les signaux que le robot devra écouter ou envoyer
#Passer par un event bus permet de réduire le couplage du code et donc de le rendre plus flexible

## Id de requête pour retour
var request_id : int = 0

@warning_ignore_start("unused_signal")
# Actions emitted by graph
signal move_right(id:int)
signal move_left(id:int)
signal jump_right(id:int)
signal jump_left(id:int)
signal check_obj_right(id:int)
signal check_obj_left(id:int)
signal check_obj_under(id:int)
signal check_just_fell(id:int)
# Triggers emitted by character
signal check_is_arrived(id:int, response:bool)
signal check_obj_right_response(id:int, response:bool)
signal check_obj_left_response(id:int, response:bool)
signal check_obj_under_response(id:int, response:bool)
signal check_just_fell_response(id:int, response:bool)

func get_unused_id() -> int:
	request_id = request_id+1
	return request_id-1
