extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxBody/HBoxSFX/Control/HScrollBarSFX.value = PreloadBus.resources["options"].sfx_volume
	$HBoxBody/HBoxBGM/Control/HScrollBarBGM.value = PreloadBus.resources["options"].bgm_volume


func _on_button_back_pressed() -> void:
	PreloadBus.change_level("main_menu")


func _on_h_scroll_bar_bgm_value_changed(value) -> void:
	PreloadBus.resources["options"].bgm_volume = value 
	AudioBus.update_bgm_volume(value)


func _on_h_scroll_bar_sfx_value_changed(value) -> void:
	PreloadBus.resources["options"].sfx_volume = value
	AudioBus.update_sfx_volume(value)
