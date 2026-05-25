extends Node

## All preloaded scenes are here. A scene is a file with .tscn extension
var scenes = {
	"start_cinematic" : preload("res://Menus/StartCinematic/start_cinematic.tscn"),
	"main_menu" : preload("res://Menus/MainMenu/main_menu.tscn"),
	"option_menu" : preload("res://Menus/OptionMenu/option_menu.tscn"),
	"defeat_menu" : preload("res://Menus/DefeatMenu/defeat_menu.tscn"),
	"win_menu" : preload("res://Menus/WinMenu/win_menu.tscn"),
	"level_select" : preload("res://Menus/LevelMenu/level_menu.tscn"),
	"level_00" : preload("res://Levels/Levels/0.tscn"),
	"level_01" : preload("res://Levels/Levels/1.tscn"),
	"level_02" : preload("res://Levels/Levels/2.tscn"),
	"level_03" : preload("res://Levels/Levels/3.tscn"),
	"level_04" : preload("res://Levels/Levels/4.tscn"),
	"level_05" : preload("res://Levels/Levels/5.tscn"),
	"level_06" : preload("res://Levels/Levels/6.tscn"),
	"level_07" : preload("res://Levels/Levels/7.tscn"),
	"level_08" : preload("res://Levels/Levels/8.tscn"),
	"level_09" : preload("res://Levels/Levels/9.tscn"),
}

## All resources are here. A resource is a file with .tres or .res extension
var resources = {
	"options" = preload("res://Data/options_data.tres"),
	"robot" = preload("res://Data/robot_data.tres"),
	"progression" =  preload("res://Data/progression_data.tres")
}

var bgm = {
	"combat_loop" = preload("res://Assets/Bgm/combat_loop.mp3"),
	"main" = preload("res://Assets/Bgm/main.mp3"),
	"main_loop" = preload("res://Assets/Bgm/main_loop.mp3"),
	"title" = preload("res://Assets/Bgm/title.mp3"),
}

var sfx = {
	"hover" = preload("res://Assets/Sfx/hover.ogg"),
	"click" = preload("res://Assets/Sfx/Button Clicked.wav"),
	"step1" = preload("res://Assets/Sfx/Step 1.wav"),
	"step2" = preload("res://Assets/Sfx/Step 2.wav"),
	"fall" = preload("res://Assets/Sfx/Fall.wav"),
	"saved" = preload("res://Assets/Sfx/Astronaut Saved.wav"),
	"jump" = preload("res://Assets/Sfx/Jump Up.wav")
}
## All references are here. They can be accessed by root
## Might need to change place in a later date
@onready var references = {
	"game" : get_node("/root/Game"),
	"level" : get_node("/root/Game/Level"),
	"bgm_player" : get_node("/root/Game/AudioStreamBGM"),
}

signal level_changed(scene)

func change_level(scene_name) -> void:
## Change scene in the level node. It will kill all level's children
	if scenes.has(scene_name):
		for child in references.level.get_children():
			child.queue_free()
		var scene = scenes[scene_name].instantiate()
		references.level.add_child(scene)
		level_changed.emit(scene)
	else:
		push_error("Can not acces this scene_name. Is this key defined in scenes dict?")
