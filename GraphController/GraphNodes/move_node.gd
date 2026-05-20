extends GraphControlNode
class_name MoveNode

@export var item_list: ItemList

var request_ids : Array[int] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
			pass
		1:
			EventBus.move_left.emit(request)
			request_sent = true
		2:
			EventBus.move_right.emit(request)
			request_sent = true
		3:
			pass
		_:
			pass
	if request_sent:
		request_ids.push_back(request)
	
func feedback_received(feedback_id : int, _move_success: bool) -> void:
	if not feedback_id in request_ids:
		pass
	pass
