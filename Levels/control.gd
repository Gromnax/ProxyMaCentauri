extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ControlPhase.show()
	$ControlPhase.modulate = Color(1,1,1,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func phase_ui(text :String):
	$ControlPhase/RichTextLabel.text = text
	var tween = get_tree().create_tween()
	tween.tween_property($ControlPhase, "modulate", Color(1,1,1,1), 1)
	await get_tree().create_timer(2)
	tween.tween_property($ControlPhase, "modulate", Color(1,1,1,0), 1)
