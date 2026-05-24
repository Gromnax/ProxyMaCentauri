extends Control


func _ready() -> void:
	PreloadBus.references["bgm_player"].set_stream(PreloadBus.bgm["title"])
	PreloadBus.references["bgm_player"].play()
	$LabelTitle.modulate = Color(1,1,1,0)
	$VBoxMenu.modulate = Color(1,1,1,0)
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property($LabelTitle, "modulate", Color(1,1,1,1), 0.5)
	tween.tween_property($VBoxMenu, "modulate", Color(1,1,1,1), 0.5)

func _on_button_options_pressed() -> void:
	PreloadBus.change_level("option_menu")


func _on_button_exit_pressed() -> void:
	if OS.get_name() in ["Web", "HTML5"]:
		JavaScriptBridge.eval("window.close()")
	else:
		get_tree().quit()


func _on_button_start_pressed() -> void:
	PreloadBus.change_level("level_select")
