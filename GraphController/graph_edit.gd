extends GraphEdit
class_name GraphControlEdit

var move_scene = preload("res://GraphController/GraphNodes/MoveNode.tscn")
var pulsar_scene = preload("res://GraphController/GraphNodes/PulsarNode.tscn")
var print_scene = preload("res://GraphController/GraphNodes/Printer.tscn")

var child_number: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	print("Connection requested")
	connect_node(from_node, from_port, to_node, to_port)
	var target : Node = get_child_from_name(to_node)
	var origin : Node = get_child_from_name(from_node)
	if target is GraphControlNode and origin is GraphControlNode:
		target.listen_start(to_port, origin.output)

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	print("Disconnection requested")
	disconnect_node(from_node, from_port, to_node, to_port)
	var target : Node = get_child_from_name(to_node)
	var origin : Node = get_child_from_name(from_node)
	if target is GraphControlNode and origin is GraphControlNode:
		target.listen_stop(to_port, origin.output)

func get_child_from_name(node: StringName) -> Node:
	return get_node(NodePath(node))


func _on_child_entered_tree(node: Node) -> void:
	if node is GraphControlNode:
		node.output.connect(on_output_emitted)


func on_output_emitted(source: Node, port: int, value:String) -> void:
	var retrieved_connections = get_output_connections_from_node(source, port)
	var child : GraphControlNode
	for connection in retrieved_connections:
		child = find_child(connection.node, false, false)
		child.signal_received(connection.port, value)

func get_output_connections_from_node(node:Node, port: int) -> Array:
	var retrieved_connections = get_connection_list_from_node(node.name)
	var result = []
	for connection in retrieved_connections:
		var dict = {}
		if connection["from_node"] == node.name and connection["from_port"] == port:
			dict["node"] = connection["to_node"]
			dict["port"] = connection["to_port"]
			result.push_back(dict)
	return result


func _on_move_button_pressed() -> void:
	var new_node : MoveNode = move_scene.instantiate()
	new_node.set_name("GraphControlNode"+str(child_number))
	child_number = child_number +1
	add_child(new_node)


func _on_pulsar_button_pressed() -> void:
	var new_node : PulsarNode = pulsar_scene.instantiate()
	add_child(new_node)
	var new_name : StringName = StringName("GraphControlNode"+str(child_number))
	new_node.set_name(new_name)
	child_number = child_number +1
	new_node.owner = self
	print(new_node)
	print(find_children("*"))


func _on_print_button_pressed() -> void:
	var new_node : Printer = print_scene.instantiate()
	new_node.set_name("GraphControlNode"+str(child_number))
	child_number = child_number +1
	add_child(new_node)


func _on_counter_button_pressed() -> void:
	print("Pas encore prêt")
