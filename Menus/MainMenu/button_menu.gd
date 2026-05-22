extends Button

var is_hovered = false

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pressed.connect(_on_pressed)

func _on_mouse_entered() -> void:
	AudioBus.play_sfx(PreloadBus.sfx["hover"])
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property($HBoxContainer/PanelSeparator, "custom_minimum_size:x", 150, 0.2)
	tween.tween_property($HBoxContainer/PanelSeparator2, "custom_minimum_size:x", 150.0, 0.2)
	is_hovered = true

func _on_mouse_exited() -> void:
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property($HBoxContainer/PanelSeparator, "custom_minimum_size:x", 0.0, 0.2)
	tween.tween_property($HBoxContainer/PanelSeparator2, "custom_minimum_size:x", 0.0, 0.2)
	is_hovered = false

func _on_pressed() ->void:
	AudioBus.play_sfx(PreloadBus.sfx["hover"])
