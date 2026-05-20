extends Node

## All preloaded scenes are here. A scene is a file with .tscn extension
var scenes = {
	"main_menu" : preload("res://Menus/MainMenu/main_menu.tscn"),
	"option_menu" : preload("res://Menus/OptionMenu/option_menu.tscn"),
	"defeat_menu" : preload("res://Menus/DefeatMenu/defeat_menu.tscn"),
	"win_menu" : preload("res://Menus/WinMenu/win_menu.tscn"),
	"test_level" : preload("res://Levels/test.tscn"),
}

## All resources are here. A resource is a file with .tres or .res extension
var resources = {
	"options" = preload("res://Data/options_data.tres"),
	"robot" = preload("res://Data/robot_data.tres"),
	"bgm_combat_loop" = preload("res://Assets/Bgm/combat_loop.mp3"),
	"bgm_main" = preload("res://Assets/Bgm/main.mp3"),
	"bgm_main_loop" = preload("res://Assets/Bgm/main_loop.mp3"),
	"bgm_title" = preload("res://Assets/Bgm/title.mp3"),
}

var bgm = {
	"combat_loop" = preload("res://Assets/Bgm/combat_loop.mp3"),
	"main" = preload("res://Assets/Bgm/main.mp3"),
	"main_loop" = preload("res://Assets/Bgm/main_loop.mp3"),
	"title" = preload("res://Assets/Bgm/title.mp3"),
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
