extends GraphControlNode
class_name TestValueNode

var value: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_unhandled_signal_received(_args: Dictionary={}) -> void:
	pass

func signal_received(port: int, test_value:String="") -> void:
	var test_int = test_value.to_int()
	match %OptionButton.selected:
		0: #=
			emit_answer(test_int == value)
		1: #!=
			emit_answer(test_int != value)
		2: #>
			emit_answer(test_int > value)
		3: #>=
			emit_answer(test_int >= value)
		4: #<
			emit_answer(test_int < value)
		5: #<=
			emit_answer(test_int <= value)

func emit_answer(answer: bool) -> void:
	if answer:
		output.emit(self, 0, "")
	else:
		output.emit(self, 1, "")

func _on_button_value_changed(new_value: float) -> void:
	value = int(new_value)
