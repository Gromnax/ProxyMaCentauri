extends Control


func _on_button_back_pressed() -> void:
	PreloadBus.change_level("main_menu")


func _on_button_level_pressed() -> void:
	PreloadBus.change_level("level_select")
