extends Node2D

@onready var wall_layer = $"../WallLayer"
@onready var level = $".."

const TILE_SIZE := 32
const MOVE_TIME := 0.15
const JUMP_HEIGHT := 64

enum MOVEMENT {
	FALLING,
	GROUNDED
}

var current_movement := MOVEMENT.GROUNDED
var is_moving := false

func _ready() -> void:
	EventBus.move_left.connect(on_move_left)
	EventBus.move_right.connect(on_move_right)
	EventBus.jump_left.connect(on_jump_left)
	EventBus.jump_right.connect(on_jump_right)
	EventBus.check_obj_right.connect(on_check_obj_right)
	EventBus.check_obj_left.connect(on_check_obj_left)
	EventBus.check_obj_under.connect(on_check_obj_under)
	EventBus.check_just_fell.connect(on_check_just_fell)
	
func _process(delta: float) -> void:
	fall()


# --------------------------------------------------
# GRID HELPERS
# --------------------------------------------------

func world_to_cell(pos: Vector2) -> Vector2i:
	return wall_layer.local_to_map(pos)

func cell_to_world(cell: Vector2i) -> Vector2:
	return wall_layer.map_to_local(cell)

func is_blocked(cell: Vector2i) -> bool:
	var data = wall_layer.get_cell_tile_data(cell)
	if data:
		var is_astronaut = false
		if data.has_custom_data("is_astronaut"):
			is_astronaut = data.get_custom_data("is_astronaut")
		if is_astronaut : win()
	return data != null

# --------------------------------------------------
# MOVEMENT
# --------------------------------------------------

func try_move(dir: Vector2i):
	if is_moving:
		return

	var current_cell = world_to_cell(global_position)
	var target_cell = current_cell + dir

	# Wall collision
	if is_blocked(target_cell):
		EventBus.check_is_arrived.emit(false)
		return
	is_moving = true

	var target_world = cell_to_world(target_cell)

	var tween = create_tween()
	tween.tween_property(
		self,
		"global_position",
		target_world,
		MOVE_TIME
	).set_trans(Tween.TRANS_SINE)

	await tween.finished

	is_moving = false
	EventBus.check_is_arrived.emit(true)

func should_fall() -> bool:

	var current = world_to_cell(global_position)
	var below = current + Vector2i.DOWN

	
	return not is_blocked(below)
		
func fall():
	if is_moving:
		return

	var current = world_to_cell(global_position)
	var target = current

	# Cherche la dernière case libre
	while not is_blocked(target + Vector2i.DOWN):
		target += Vector2i.DOWN

	# Si aucune chute
	if target == current:
		return

	is_moving = true
	current_movement = MOVEMENT.FALLING

	var target_world = cell_to_world(target)

	var distance = abs(target.y - current.y)

	# durée proportionnelle à la distance
	var duration = MOVE_TIME * distance

	var tween = create_tween()

	tween.tween_property(
		self,
		"global_position",
		target_world,
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	await tween.finished

	is_moving = false
# --------------------------------------------------
# ACTIONS
# --------------------------------------------------

func on_move_right(id:int):
	await try_move(Vector2i.RIGHT)
	current_movement = MOVEMENT.GROUNDED

func on_move_left(id:int):
	await try_move(Vector2i.LEFT)
	current_movement = MOVEMENT.GROUNDED
	
func on_jump_right(id:int):
	await try_move(Vector2i(1, -1))
	current_movement = MOVEMENT.GROUNDED

func on_jump_left(id:int):
	await try_move(Vector2i(-1, -1))
	current_movement = MOVEMENT.GROUNDED
	
# --------------------------------------------------
# CHECKS
# --------------------------------------------------

func on_check_obj_right(id:int):
	var current = world_to_cell(global_position)
	var side = current + Vector2i.RIGHT
	await get_tree().process_frame
	EventBus.check_obj_right_response.emit(id, is_blocked(side))
	
func on_check_obj_left(id:int):
	var current = world_to_cell(global_position)
	var side = current + Vector2i.LEFT
	await get_tree().process_frame
	EventBus.check_obj_left_response.emit(id, is_blocked(side))
	
func on_check_obj_under(id:int):
	var current = world_to_cell(global_position)
	var side = current + Vector2i.DOWN
	await get_tree().process_frame
	EventBus.check_obj_under_response.emit(id, is_blocked(side))
	
func on_check_just_fell(id:int):
	var response = false
	if current_movement == MOVEMENT.FALLING:
		response = true
	EventBus.check_just_fell_response.emit(id, response)
		
func win():
	PreloadBus.change_level("win_menu")
