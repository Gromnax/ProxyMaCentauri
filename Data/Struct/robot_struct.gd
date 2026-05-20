extends Resource
class_name RobotData

@export var tick_duration : float = 1.0 :
	set(new_value):
		tick_duration = new_value
		if OS.get_name() not in ["Web", "HTML5"]:
			save()
@export var speed : float = 300.0 :
	set(new_value):
		speed = new_value
		if OS.get_name() not in ["Web", "HTML5"]:
			save()
@export var jump_speed : float = 300.0:
	set(new_value):
		jump_speed = new_value
		if OS.get_name() not in ["Web", "HTML5"]:
			save()
@export var max_energy : int = 100:
	set(new_value):
		max_energy = new_value
		if OS.get_name() not in ["Web", "HTML5"]:
			save()
@export var energy : int = 100:
	set(new_value):
		energy = new_value
		if OS.get_name() not in ["Web", "HTML5"]:
			save()

func save() -> void :
	ResourceSaver.save(self, "res://Data/robot_data.tres")
