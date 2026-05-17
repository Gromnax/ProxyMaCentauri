extends GraphControlNode
class_name PulsarNode

@export var timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_unhandled_signal_received(args: Array=[]) -> void:
	pass


func _on_timer_timeout() -> void:
	output.emit()
	print("Timer timeout!!")
