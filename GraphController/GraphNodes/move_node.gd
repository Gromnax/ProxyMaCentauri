extends GraphControlNode
class_name MoveNode

@export var item_list: ItemList

#var request_ids : Array[int] = []
var request_ids : Dictionary[int, String] = {}

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
	request_ids[request] = ""
	if selected_items.size()<1:
		return
	match selected_items[0]:
		0:
			EventBus.jump_left.emit(request)
		1:
			EventBus.move_left.emit(request)
		2:
			EventBus.move_right.emit(request)
		3:
			EventBus.jump_right.emit(request)
	
func feedback_received(feedback_id : int, move_success: bool) -> void:
	#await get_tree().create_timer(1).timeout
	print("feedback received!")
	if not request_ids.has(feedback_id):
		return
	var before_size = request_ids.size()
	request_ids.erase(feedback_id)
	var after_size = request_ids.size()
	if move_success:
		#print("Output emit 0")
		output.emit(self, 0, "moved")
		return
	else:
		#print("Output emit 1")
		output.emit(self, 1, "move_failed")
		return
