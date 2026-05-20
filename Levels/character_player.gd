extends CharacterBody2D

## Distance covered in 1tick
@onready var speed :float = PreloadBus.resources["robot"].speed
## Distance covered while jumping in 1tick
@onready var jump_speed :float = -PreloadBus.resources["robot"].jump_speed
@onready var level = $".."
@onready var camera = $Camera2D
enum MOVEMENT {FALLING, JUMPING, GROUNDED}
const str_movement = ["Falling", "Jumping", "Grounded"]
var current_movement : MOVEMENT = MOVEMENT.GROUNDED


var detections = {
	"right" : false, 
	"left" : false, 
	"under" : false
	}
var action_step = 0
var pseudo_code = [
	{
		"actions": ["move_right"],
		"until": {
			"type" : "detect_right",
			"value" : true
		}
	},
	{
		"actions": ["jump","move_right"],
		"until": {
			"type" : "detect_under",
			"value" : false
		}
	},
	{
		"actions": ["move_right"],
		"until": {
			"type" : "falling",
			"value" : true
		}
	},
	{
		"actions": [],
		"until": {
			"type" : "grounded",
			"value" : true
		}
	},
	{
		"actions": ["move_left"],
		"until": {
			"type" : "detect_left",
			"value" : true
		}
	},
]

func _ready() -> void:
	level.phase_changed.connect(_on_phase_changed)
	EventBus.pseudo_code_changed.connect(_on_pseudo_code_changed)

func _physics_process(delta: float) -> void:
	if level.current_phase == level.PHASE.PLANNING:
		pass
	elif level.current_phase == level.PHASE.RUNNING:
		check_is_moving()
		check_block_right()
		check_block_left()
		check_block_under()
		
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		execute_pseudo_code()
		move_and_slide()

func check_is_moving():
	if not is_on_floor() and current_movement != MOVEMENT.JUMPING:
		current_movement = MOVEMENT.FALLING
	elif is_on_floor():
		current_movement = MOVEMENT.GROUNDED

func check_block_right():
	## Returns true if there is a block in a 48px distance (1.5 tile) on the robot's right
	if $RayCast2DRight.is_colliding():
		detections["right"] = true
		var obj = $RayCast2DRight.get_collider()
		if obj.is_in_group("astronaut"):
			win()
	else:
		detections["right"] = false
	
func check_block_left():
	## Returns true if there is a block in a 48px distance (1.5 tile) on the robot's left
	if $RayCast2DLeft.is_colliding():
		detections["left"] = true
		var obj = $RayCast2DLeft.get_collider()
		if obj.is_in_group("astronaut"):
			win()
	else:
		detections["left"] = false

func check_block_under():
	## Returns true if there is a block under the robot
	if $RayCast2DUnder.is_colliding() :
		detections["under"] = true
		var obj = $RayCast2DUnder.get_collider()
		if obj.is_in_group("astronaut"):
			win()
	else:
		detections["under"] = false


func move_right():
	velocity.x = speed
	
func move_left():
	velocity.x = -speed

func move_stop():
	velocity.x = 0
	if is_on_floor():
		velocity.y = 0
	
func jump():
	if is_on_floor():
		velocity.y = jump_speed
		current_movement = MOVEMENT.JUMPING

func win():
	PreloadBus.change_level("win_menu")

func execute_pseudo_code():
	if action_step >= pseudo_code.size():
		move_stop()
		return

	var instruction = pseudo_code[action_step]

	# EXECUTE ACTIONS

	move_stop()

	for action in instruction["actions"]:

		match action:

			"move_right":
				move_right()

			"move_left":
				move_left()

			"jump":
				jump()

	# CHECK CONDITION

	var condition = instruction["until"]

	match condition["type"]:

		"detect_right":
			if detections["right"] == condition["value"]:
				action_step += 1

		"detect_left":
			if detections["left"] == condition["value"]:
				action_step += 1

		"detect_under":
			if detections["under"] == condition["value"]:
				action_step += 1

		"grounded":
			var grounded = current_movement == MOVEMENT.GROUNDED

			if grounded == condition["value"]:
				action_step += 1

		"falling":
			var falling = current_movement == MOVEMENT.FALLING

			if falling == condition["value"]:
				action_step += 1

		"jumping":
			var jumping = current_movement == MOVEMENT.JUMPING

			if jumping == condition["value"]:
				action_step += 1

func _on_phase_changed(phase):
	if phase == level.PHASE.PLANNING:
		position = level.start_position
		action_step = 0
		
func _on_pseudo_code_changed(_pseudo_code):
	pseudo_code = _pseudo_code
