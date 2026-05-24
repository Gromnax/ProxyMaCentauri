extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Button00.disabled = !PreloadBus.resources["progression"].unlock_00
	$VBoxContainer/Button01.disabled = !PreloadBus.resources["progression"].unlock_01
	$VBoxContainer/Button02.disabled = !PreloadBus.resources["progression"].unlock_02
	$VBoxContainer/Button03.disabled = !PreloadBus.resources["progression"].unlock_03
	$VBoxContainer/Button04.disabled = !PreloadBus.resources["progression"].unlock_04
	$VBoxContainer/Button05.disabled = !PreloadBus.resources["progression"].unlock_05
	$VBoxContainer/Button06.disabled = !PreloadBus.resources["progression"].unlock_06
	$VBoxContainer/Button07.disabled = !PreloadBus.resources["progression"].unlock_07
	$VBoxContainer/Button08.disabled = !PreloadBus.resources["progression"].unlock_08
	$VBoxContainer/Button09.disabled = !PreloadBus.resources["progression"].unlock_09

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_00_pressed() -> void:
	PreloadBus.change_level("level_00")


func _on_button_01_pressed() -> void:
	PreloadBus.change_level("level_01")


func _on_button_02_pressed() -> void:
	PreloadBus.change_level("level_02")


func _on_button_03_pressed() -> void:
	PreloadBus.change_level("level_03")


func _on_button_04_pressed() -> void:
	PreloadBus.change_level("level_04")


func _on_button_05_pressed() -> void:
	PreloadBus.change_level("level_05")


func _on_button_06_pressed() -> void:
	PreloadBus.change_level("level_06")


func _on_button_07_pressed() -> void:
	PreloadBus.change_level("level_07")


func _on_button_08_pressed() -> void:
	PreloadBus.change_level("level_08")


func _on_button_09_pressed() -> void:
	PreloadBus.change_level("level_09")


func _on_button_title_pressed() -> void:
	PreloadBus.change_level("main_menu")
