extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not PreloadBus.resources["options"].cinematic : start_game()
	$AudioStreamPlayer.play(99.25)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game():
	PreloadBus.change_level("main_menu")
