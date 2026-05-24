extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		visible = !visible


func _on_button_title_pressed() -> void:
	PreloadBus.change_level("main_menu")


func _on_button_unpause_pressed() -> void:
	hide()


func _on_button_exit_pressed() -> void:
	if OS.get_name() in ["Web", "HTML5"]:
		JavaScriptBridge.eval("window.close()")
	else:
		get_tree().quit()
