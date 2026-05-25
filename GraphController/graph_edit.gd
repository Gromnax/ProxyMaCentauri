extends GraphEdit
class_name GraphControlEdit

var move_scene = preload("res://GraphController/GraphNodes/MoveNode.tscn")
var pulsar_scene = preload("res://GraphController/GraphNodes/PulsarNode.tscn")
var pulsar_once_scene = preload("res://GraphController/GraphNodes/PulsarNodeOnce.tscn")
var print_scene = preload("res://GraphController/GraphNodes/Printer.tscn")
var pulsar_clic_scene = preload("res://GraphController/GraphNodes/PulsarNodeClic.tscn")
var check_move_scene = preload("res://GraphController/GraphNodes/CheckMoveNode.tscn")
var check_fell_scene = preload("res://GraphController/GraphNodes/FallDetector.tscn")

var child_number: int = 0

@onready var popup_menu: Control = $"PopupMenu"

var zoom_enabled := true
var locked_zoom := 1.0

var has_started : bool = false:
	set(new_value):
		if not has_started and new_value:
			EventBus.level_start.emit()
			print("Level started")
		has_started = new_value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.level_retry.connect(retry)

func retry() -> void:
	has_started = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			popup_menu.visible = !popup_menu.visible
			popup_menu.global_position = event.global_position
			zoom_enabled = false
			locked_zoom = zoom
		if not zoom_enabled:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP \
			or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:

				zoom = locked_zoom
				accept_event()
	if Input.is_action_just_pressed("delete"):
		delete_selected_nodes()

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	if has_started:
		print("Can't connect while running")
		return
	print("Connection requested")
	connect_node(from_node, from_port, to_node, to_port)
	var target : Node = get_child_from_name(to_node)
	var origin : Node = get_child_from_name(from_node)
	if target is GraphControlNode and origin is GraphControlNode:
		target.listen_start(to_port, origin.output)

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	if has_started:
		print("Can't disconnect while running")
		return
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
	if not has_started:
		if source is PulsarClic or source is PulsarNode:
			has_started = true
		else:
			return
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
	close_popup()
	set_graph_node_to_mouse(new_node)


func _on_pulsar_button_pressed() -> void:
	var new_node : PulsarNode = pulsar_scene.instantiate()
	add_child(new_node)
	var new_name : StringName = StringName("GraphControlNode"+str(child_number))
	new_node.set_name(new_name)
	child_number = child_number +1
	new_node.owner = self
	print(new_node)
	print(find_children("*"))
	close_popup()
	set_graph_node_to_mouse(new_node)


func _on_print_button_pressed() -> void:
	var new_node : Printer = print_scene.instantiate()
	new_node.set_name("GraphControlNode"+str(child_number))
	child_number = child_number +1
	add_child(new_node)
	close_popup()
	set_graph_node_to_mouse(new_node)


func _on_counter_button_pressed() -> void:
	print("Pas encore prêt")


func _on_pulsar_once_button_pressed() -> void:
	var new_node : PulsarNode = pulsar_once_scene.instantiate()
	new_node.set_name("GraphControlNode"+str(child_number))
	child_number = child_number +1
	add_child(new_node)
	close_popup()
	set_graph_node_to_mouse(new_node)


func _on_pulsar_clic_button_pressed() -> void:
	var new_node : PulsarClic = pulsar_clic_scene.instantiate()
	new_node.set_name("GraphControlNode"+str(child_number))
	child_number = child_number +1
	add_child(new_node)
	close_popup()
	set_graph_node_to_mouse(new_node)

func set_graph_node_to_mouse(graph_node):
	var local_mouse_pos = get_local_mouse_position()
	var target_offset = (local_mouse_pos + scroll_offset) / zoom

	graph_node.position_offset = target_offset

func close_popup():
	popup_menu.hide()
	zoom_enabled = true
	
func delete_selected_nodes() -> void:
	var nodes_to_delete := []

	# Collect selected GraphNodes
	for child in get_children():
		if child is GraphNode and child.selected:
			nodes_to_delete.append(child)

	# Delete connections first
	for node in nodes_to_delete:
		var connections = get_connection_list()

		for connection in connections:
			if connection.from_node == node.name \
			or connection.to_node == node.name:

				disconnect_node(
					connection.from_node,
					connection.from_port,
					connection.to_node,
					connection.to_port
				)

	for node in nodes_to_delete:
		node.queue_free()


func _on_check_button_pressed() -> void:
	var new_node : CheckMoveNode = check_move_scene.instantiate()
	new_node.set_name("GraphControlNode"+str(child_number))
	child_number = child_number +1
	add_child(new_node)
	close_popup()
	set_graph_node_to_mouse(new_node)


func _on_fell_button_pressed() -> void:
	var new_node : FallDetector = check_fell_scene.instantiate()
	new_node.set_name("GraphControlNode"+str(child_number))
	child_number = child_number +1
	add_child(new_node)
	close_popup()
	set_graph_node_to_mouse(new_node)
