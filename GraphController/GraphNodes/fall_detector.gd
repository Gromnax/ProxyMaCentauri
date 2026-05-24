extends GraphControlNode
class_name FallDetector

var request_ids : Array[int] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.check_just_fell_response.connect(feedback_received)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func on_unhandled_signal_received(_args: Dictionary={}) -> void:
	pass

func signal_received(port: int, _value:String="") -> void:
	if port != 0:
		return
	var request : int = EventBus.get_unused_id()	
	EventBus.check_just_fell.emit(request)
	request_ids.push_back(request)

func feedback_received(feedback_id : int, move_success: bool) -> void:
	if request_ids.find(feedback_id)==-1:
		return
	request_ids.erase(feedback_id)
	if move_success:
		output.emit(self, 0, "just_fell")
	else:
		output.emit(self, 1, "did_not_fall")
