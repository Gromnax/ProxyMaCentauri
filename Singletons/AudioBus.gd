extends Node

func update_bgm_volume(volume: float) -> void:
	for audioplayer in get_tree().get_nodes_in_group("bgm"):
		audioplayer.volume_db = linear_to_db(volume)
		
func update_sfx_volume(volume: float) -> void:
	for audioplayer in get_tree().get_nodes_in_group("sfx"):
		audioplayer.volume_db = linear_to_db(volume)
