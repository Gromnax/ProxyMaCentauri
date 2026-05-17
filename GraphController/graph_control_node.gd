extends GraphNode
class_name GraphControlNode
signal hello_sent()
@export var robot_signals : Dictionary[String, Signal] = {"Hello": hello_sent}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_hello_sent() -> void:
	print("Coucou")


func _on_label_pressed() -> void:
	hello_sent.emit()
