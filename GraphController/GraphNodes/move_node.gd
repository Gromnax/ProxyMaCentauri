extends GraphControlNode
class_name MoveNode

@export var item_list: ItemList

var request_ids : Array[int] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.check_is_arrived.connect(feedback_received)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func on_unhandled_signal_received(_args: Dictionary={}) -> void:
	pass

func signal_received(_port: int, _value:String="") -> void:
	var selected_items : Array = item_list.get_selected_items()
	var request : int = EventBus.get_unused_id()
	
	var request_sent : bool = false
	if selected_items.size() == 0:
		return

	match selected_items[0]:
		0:
			EventBus.jump_left.emit(request)
			request_sent = true
			print("jump gauche")
		1:
			EventBus.move_left.emit(request)
			request_sent = true
			print("gauche")
		2:
			EventBus.move_right.emit(request)
			request_sent = true
			print("droite")
		3:
			EventBus.jump_right.emit(request)
			request_sent = true
			print("jump droite")
		_:
			pass
	if request_sent:
		request_ids.push_back(request)
	
func feedback_received(feedback_id : int, move_success: bool) -> void:
	if request_ids.find(feedback_id)==-1:
		return
	request_ids.erase(feedback_id)
	if move_success:
		output.emit(self, 0, "moved")
	else:
		print("failed")
		output.emit(self, 1, "move_failed")
