extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ControlPhase.modulate = Color(1,1,1,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func phase_ui(text :String):
	$ControlPhase/RichTextLabel.text = text
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property($ControlPhase, "modulate", Color(1,1,1,1), 0.2)
	tween.tween_property($ControlPhase, "psition:y", position.y - 20, 0.2)
	await get_tree().create_timer(1)
	tween.tween_property($ControlPhase, "modulate", Color(1,1,1,0), 0.2)
	tween.tween_property($ControlPhase, "psition:y", position.y - 20, 0.2)
