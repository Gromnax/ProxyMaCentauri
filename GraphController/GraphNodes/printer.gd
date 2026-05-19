extends GraphControlNode
class_name Printer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_unhandled_signal_received(args: Dictionary={}) -> void:
	print("Signal received!")

func signal_received(port: int, value:String="") -> void:
	print("Received value: " + value + " on port " + str(port))
