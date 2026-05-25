extends Control

var done :bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if not done:
			on_right_click()

# Usage in another function:
func on_right_click():
	done = true
	var tween = get_tree().create_tween()
	tween.tween_property($Label01, "modulate", Color(1,1,1,0),0.2)
	$Label01.hide()
	$Label02.modulate = Color(1,1,1,0)
	$Label02.show()
	tween.tween_property($Label02, "modulate", Color(1,1,1,1),0.2)
