class_name ProgressionData
extends Resource

@export var unlock_00 : bool = true :
	set(new_value):
		unlock_00 = new_value
		if OS.get_name() not in ["Web", "HTML5"]:
			save()

@export var unlock_01 : bool = false :
	set(new_value):
		unlock_01 = new_value
		if OS.get_name() not in ["Web", "HTML5"]:
			save()
			
@export var unlock_02 : bool = false :
	set(new_value):
		unlock_02 = new_value
		if OS.get_name() not in ["Web", "HTML5"]:
			save()
			
@export var unlock_03 : bool = false :
	set(new_value):
		unlock_03 = new_value
		if OS.get_name() not in ["Web", "HTML5"]:
			save()

@export var unlock_04 : bool = false :
	set(new_value):
		unlock_04 = new_value
		if OS.get_name() not in ["Web", "HTML5"]:
			save()

@export var unlock_05 : bool = false :
	set(new_value):
		unlock_05 = new_value
		if OS.get_name() not in ["Web", "HTML5"]:
			save()

@export var unlock_06 : bool = false :
	set(new_value):
		unlock_06 = new_value
		if OS.get_name() not in ["Web", "HTML5"]:
			save()
			
@export var unlock_07 : bool = false :
	set(new_value):
		unlock_07 = new_value
		if OS.get_name() not in ["Web", "HTML5"]:
			save()
			
@export var unlock_08 : bool = false :
	set(new_value):
		unlock_08 = new_value
		if OS.get_name() not in ["Web", "HTML5"]:
			save()

@export var unlock_09 : bool = false :
	set(new_value):
		unlock_09 = new_value
		if OS.get_name() not in ["Web", "HTML5"]:
			save()

func save() -> void :
	ResourceSaver.save(self, "res://Data/progression_data.tres")
