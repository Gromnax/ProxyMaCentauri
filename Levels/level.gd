extends Node2D
@export var tries: int = 3
@export var unlock_level : String
var current_try : int = tries :
	set(new_value):
		if new_value <= 0:
			PreloadBus.change_level("defeat_menu")
		current_try = new_value
		update_ui_retry()
@export var start_position : Vector2 = Vector2.ZERO
enum PHASE{PLANNING, RUNNING}
var current_phase : PHASE = PHASE.PLANNING
signal phase_changed(phase:PHASE)

func _ready() -> void:
	EventBus.level_start.connect(start)
	PreloadBus.references["bgm_player"].set_stream(PreloadBus.bgm["main_loop"])
	PreloadBus.references["bgm_player"].play()
	update_ui_retry()
	$CanvasLayer/Control.phase_ui("Programming robot")
	

func _on_button_retry_pressed() -> void:
	current_phase = PHASE.PLANNING
	current_try -= 1
	phase_changed.emit(current_phase)
	$CanvasLayer/Control/PanelContainer/VBoxContainer/ButtonRetry.disabled = true
	$CanvasLayer/Control/PanelContainer/VBoxContainer/ButtonRetry.hide()
	$Robot/Camera2D.enabled = false
	$Camera2DOverview.enabled = true
	$CanvasLayer/Control/VBoxContainer.show()
	$Robot.global_position = start_position
	EventBus.level_retry.emit()
	$CanvasLayer/Control.phase_ui("Programming robot")

func start() -> void:
	current_phase = PHASE.RUNNING
	phase_changed.emit(current_phase)
	$CanvasLayer/Control/PanelContainer/VBoxContainer/ButtonRetry.disabled = false
	$CanvasLayer/Control/PanelContainer/VBoxContainer/ButtonRetry.show()
	$Robot/Camera2D.enabled = true
	$Camera2DOverview.enabled = false
	$CanvasLayer/Control/VBoxContainer.hide()
	$CanvasLayer/Control.phase_ui("Deploying robot")

func update_ui_retry():
	$CanvasLayer/Control/PanelContainer/VBoxContainer/ButtonRetry.text = "Retry (%s left)" % str(current_try - 1)
