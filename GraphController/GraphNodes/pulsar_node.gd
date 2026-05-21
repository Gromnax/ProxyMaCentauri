extends GraphControlNode
class_name PulsarNode

@export var timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func on_unhandled_signal_received(_args: Dictionary={}) -> void:
	pass


func _on_timer_timeout() -> void:
	output.emit(self, 0, "hello there")

## @unused This GraphNode has no entry point, this is by design.
func signal_received(_port: int, _value:String="") -> void:
	pass
