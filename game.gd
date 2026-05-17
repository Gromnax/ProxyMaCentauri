extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PreloadBus.change_level("main_menu")
	AudioBus.update_bgm_volume(PreloadBus.resources["options"].bgm_volume)
	AudioBus.update_sfx_volume(PreloadBus.resources["options"].sfx_volume)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
