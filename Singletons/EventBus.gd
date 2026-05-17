extends Node

#Ici on met en place les signaux que le robot devra écouter ou envoyer
#Passer par un event bus permet de réduire le couplage du code et donc de le rendre plus flexible

@warning_ignore_start("unused_signal")
signal move_left
signal move_right
signal jump
signal hover_start
signal hover_stop
signal grab
signal grab_result(value:bool)
signal spend_energy(amount:int)
signal recharge(amount:int)
signal out_of_energy
