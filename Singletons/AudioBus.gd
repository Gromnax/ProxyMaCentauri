extends Node

func update_bgm_volume(volume: float) -> void:
	var bus_index = AudioServer.get_bus_index("BGM")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))
		
func update_sfx_volume(volume: float) -> void:
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))

func play_sfx(sfx):
	var audio_player = AudioStreamPlayer.new()
	audio_player.set_stream(sfx)
	audio_player.bus = "SFX" # Optional: assign to a specific audio bus
	add_child(audio_player)
	audio_player.play()
	audio_player.finished.connect(audio_player.queue_free)
