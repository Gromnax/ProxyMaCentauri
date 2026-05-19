extends Control

func _ready() -> void:
	PreloadBus.references["bgm_player"].set_stream(PreloadBus.bgm["combat_loop"])
	PreloadBus.references["bgm_player"].play()

func _on_button_back_pressed() -> void:
	PreloadBus.change_level("main_menu")
