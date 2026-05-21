extends Node

#Ici on met en place les signaux que le robot devra écouter ou envoyer
#Passer par un event bus permet de réduire le couplage du code et donc de le rendre plus flexible

@warning_ignore_start("unused_signal")
#old
signal pseudo_code_changed(pseudo_code : Array)

# Actions emitted by graph
signal move_right
signal move_left
signal jump_right
signal jump_left
signal check_obj_right
signal check_obj_left
signal check_obj_under
signal check_just_fell
# Triggers emitted by character
signal check_is_arrived(response:bool)
signal check_obj_right_response(response:bool)
signal check_obj_left_response(response:bool)
signal check_obj_under_response(response:bool)
signal check_just_fell_response(response:bool)
