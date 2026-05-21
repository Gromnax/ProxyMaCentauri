extends Control

@onready var buttons = [
	$HBoxContainer/VBoxContainer/ButtonMoveRight,
	$HBoxContainer/VBoxContainer2/ButtonMoveLeft,
	$HBoxContainer/VBoxContainer3/ButtonJumpRight,
	$HBoxContainer/VBoxContainer4/ButtonJumpLeft,
	$HBoxContainer/VBoxContainer5/ButtonCheckRight,
	$HBoxContainer/VBoxContainer6/ButtonCheckLeft,
	$HBoxContainer/VBoxContainer7/ButtonCheckUnder,
	$HBoxContainer/VBoxContainer8/ButtonCheckFell,
]

func _ready() -> void:
	pass
	# IMPORTANT : Le check_is_arrived et tout les reponse doivent etre précisement aprés le check.
	# Si il y a une ligne de code entre nottament une boucle, il attendra le signal qui est déja passé.
	# Forcer un delai est possible mais inconsistent.
	#EventBus.move_right.emit(0)
	#await EventBus.check_is_arrived
	#EventBus.move_right.emit(0)
	#await EventBus.check_is_arrived
	#EventBus.move_right.emit(0)
	#await EventBus.check_is_arrived
	#EventBus.move_right.emit(0)
	#await EventBus.check_is_arrived
	#EventBus.move_right.emit(0)
	#await EventBus.check_is_arrived
	#EventBus.move_left.emit(0)
	#await EventBus.check_is_arrived
	#EventBus.move_left.emit(0)
	#await EventBus.check_is_arrived
	#EventBus.move_left.emit(0)
	#await EventBus.check_is_arrived
	#EventBus.move_left.emit(0)
	#await EventBus.check_is_arrived

func _on_button_move_right_pressed() -> void:
	EventBus.move_right.emit(0)
	var response = await EventBus.check_is_arrived
	for btn in buttons:
		btn.disabled = true
	for btn in buttons:
		btn.disabled = false
	$HBoxContainer/VBoxContainer/LabelResult.text = str(response)

func _on_button_move_left_pressed() -> void:
	EventBus.move_left.emit(0)
	var response = await EventBus.check_is_arrived
	for btn in buttons:
		btn.disabled = true
	for btn in buttons:
		btn.disabled = false
	$HBoxContainer/VBoxContainer2/LabelResult.text = str(response)


func _on_button_jump_right_pressed() -> void:
	EventBus.jump_right.emit(0)
	var response = await EventBus.check_is_arrived
	for btn in buttons:
		btn.disabled = true
	await get_tree().process_frame
	for btn in buttons:
		btn.disabled = false
	$HBoxContainer/VBoxContainer3/LabelResult.text = str(response)


func _on_button_jump_left_pressed() -> void:
	EventBus.jump_left.emit(0)
	var response = await EventBus.check_is_arrived
	for btn in buttons:
		btn.disabled = true
	await get_tree().process_frame
	for btn in buttons:
		btn.disabled = false
	$HBoxContainer/VBoxContainer4/LabelResult.text = str(response)


func _on_button_check_right_pressed() -> void:
	EventBus.check_obj_right.emit(0)
	var response = await EventBus.check_obj_right_response
	for btn in buttons:
		btn.disabled = true
	for btn in buttons:
		btn.disabled = false
	$HBoxContainer/VBoxContainer5/LabelResult.text = str(response)


func _on_button_check_left_pressed() -> void:
	EventBus.check_obj_left.emit(0)
	var response = await EventBus.check_obj_left_response
	for btn in buttons:
		btn.disabled = true
	for btn in buttons:
		btn.disabled = false
	$HBoxContainer/VBoxContainer6/LabelResult.text = str(response)


func _on_button_check_under_pressed() -> void:
	EventBus.check_obj_under.emit(0)
	var response = await EventBus.check_obj_under_response
	for btn in buttons:
		btn.disabled = true
	for btn in buttons:
		btn.disabled = false
	$HBoxContainer/VBoxContainer7/LabelResult.text = str(response)


func _on_button_check_fell_pressed() -> void:
	EventBus.check_just_fell.emit(0)
	var response = await EventBus.check_just_fell_response
	for btn in buttons:
		btn.disabled = true
	for btn in buttons:
		btn.disabled = false
	$HBoxContainer/VBoxContainer8/LabelResult.text = str(response)
