extends GraphControlNode
class_name CounterNode

@export var value_label : Label

@export var slota_option : OptionButton
@export var slota_number : SpinBox

@export var slotb_option : OptionButton
@export var slotb_number : SpinBox

var options : Array[Dictionary] = []

var value : int = 0:
	set(new_value):
		value = new_value
		value_label.text = str(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	options = [
	{"option": slota_option,
	"number": slota_number},
	
	{"option": slotb_option,
	"number": slotb_number},
	]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func on_unhandled_signal_received(_args: Dictionary={}) -> void:
	pass

func signal_received(port: int, _signal_value:String="") -> void:
	var old_value: int = value
	
	var selected_option : OptionButton = options[port]["option"]
	var selected_value : SpinBox = options[port]["number"]
	match selected_option.selected:
		0:
			value += int(selected_value.value)
		1:
			value -= int(selected_value.value)
		2:
			value *= int(selected_value.value)
		3:
			value /= int(selected_value.value)
		4:
			value %= int(selected_value.value)
		5:
			value = int(selected_value.value)
	output.emit(self,0,str(value))
	print("Old value:"+str(old_value)+" - New value:"+str(value))
