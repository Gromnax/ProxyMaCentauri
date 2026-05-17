extends HBoxContainer

@export var toogle : bool = false

func _ready() -> void:
	update_button()

func _on_button_on_pressed() -> void:
	toogle = true
	$ButtonOff.set_pressed(false)
	update_button()
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_button_off_pressed() -> void:
	toogle = false
	$ButtonOn.set_pressed(false)
	update_button()
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func update_button() -> void:
	$ButtonOn.disabled = toogle
	$ButtonOff.disabled = !toogle
	PreloadBus.resources["options"].full_screen = toogle
