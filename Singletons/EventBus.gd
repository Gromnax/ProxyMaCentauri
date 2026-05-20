extends Node

#Ici on met en place les signaux que le robot devra écouter ou envoyer
#Passer par un event bus permet de réduire le couplage du code et donc de le rendre plus flexible

@warning_ignore_start("unused_signal")
signal pseudo_code_changed(pseudo_code : Array)

signal move_left;
signal move_right;
