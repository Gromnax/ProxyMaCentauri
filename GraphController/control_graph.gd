extends VBoxContainer

var info_node_scene = preload("res://GraphController/GraphNodes/GraphInfoNode.tscn")
@export var info: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var info_node : GraphInfoNode = info_node_scene.instantiate()
	info_node.text = info
	%GraphEdit.add_child(info_node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
