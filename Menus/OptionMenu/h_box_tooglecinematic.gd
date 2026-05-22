extends HBoxContainer

@onready var toogle : bool = PreloadBus.resources["options"].cinematic

func _ready() -> void:
	update_button()

func _on_button_on_pressed() -> void:
	toogle = true
	$ButtonOff.set_pressed(false)
	update_button()

func _on_button_off_pressed() -> void:
	toogle = false
	$ButtonOn.set_pressed(false)
	update_button()

func update_button() -> void:
	$ButtonOn.disabled = toogle
	$ButtonOff.disabled = !toogle
	PreloadBus.resources["options"].cinematic = toogle
	print(PreloadBus.resources["options"].cinematic)
