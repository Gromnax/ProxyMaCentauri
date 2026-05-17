extends Control



func _on_button_options_pressed() -> void:
	PreloadBus.change_level("option_menu")


func _on_button_exit_pressed() -> void:
	if OS.get_name() in ["Web", "HTML5"]:
		JavaScriptBridge.eval("window.close()")
	else:
		get_tree().quit()
