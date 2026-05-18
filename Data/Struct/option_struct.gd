extends Resource
class_name OptionsData

var screen_option
@export var bgm_volume : float = 1.0 :
	set(new_value):
		bgm_volume = new_value
		if OS.get_name() not in ["Web", "HTML5"]:
			save()
@export var sfx_volume : float = 1.0 :
	set(new_value):
		sfx_volume = new_value
		if OS.get_name() not in ["Web", "HTML5"]:
			save()
		
@export var full_screen : bool = false :
	set(new_value):
		full_screen = new_value
		if OS.get_name() not in ["Web", "HTML5"]:
			save()

func save() -> void :
	ResourceSaver.save(self, "res://Data/options_data.tres")
