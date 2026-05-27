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
	await get_tree().create_timer(1).timeout
	var selected_items : Array = item_list.get_selected_items()
	var request : int = EventBus.get_unused_id()
	request_ids.push_back(request)
	var request_sent : bool = false
	print("Size selected items: "+str(selected_items.size()))
	print(str(selected_items))
	if selected_items.size() != 0:
		request_sent = true
	else:
		return
	print("Item selection: "+str(selected_items[0]))
	match selected_items[0]:
		0:
			EventBus.jump_left.emit(request)
		1:
			EventBus.move_left.emit(request)
		2:
			EventBus.move_right.emit(request)
		3:
			EventBus.jump_right.emit(request)
	print("After match!")
	request_ids.push_back(request)
	print("Adding request: "+str(request))
	print("Request_id new status : "+str(request_ids))
	
func feedback_received(feedback_id : int, move_success: bool) -> void:
	print("Feedback received: Feedback_id "+str(feedback_id))
	print("Feedback received: request_ids "+str(request_ids))
	print("Move_success "+str(move_success))
	#print(request_ids.find(feedback_id))
	if request_ids.find(feedback_id)==-1:
		return
	request_ids.remove_at(request_ids.find(feedback_id))
	if move_success:
		print("success")
		output.emit(self, 0, "moved")
	else:
		print("failed")
		output.emit(self, 1, "move_failed")
