extends Control


func _ready() -> void:
	PreloadBus.references["bgm_player"].set_stream(PreloadBus.bgm["title"])
	PreloadBus.references["bgm_player"].play()

func _on_button_options_pressed() -> void:
	PreloadBus.change_level("option_menu")


func _on_button_exit_pressed() -> void:
	if OS.get_name() in ["Web", "HTML5"]:
		JavaScriptBridge.eval("window.close()")
	else:
		get_tree().quit()


func _on_button_start_pressed() -> void:
	PreloadBus.change_level("test_level")
