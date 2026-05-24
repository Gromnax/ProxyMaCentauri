extends Node2D

@onready var boundary_layer : TileMapLayer = $"../BoundaryLayer"
@onready var obstacle1_layer : TileMapLayer = $"../Obstacle1Layer"
@onready var obstacle2_layer : TileMapLayer = $"../Obstacle2Layer"
var collision_layers = [boundary_layer, obstacle1_layer, obstacle2_layer]
@onready var current_obstacle_layer : TileMapLayer = obstacle1_layer

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
	EventBus.check_obj.connect(on_check_obj)
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
	return boundary_layer.local_to_map(pos)

func cell_to_world(cell: Vector2i) -> Vector2:
	return boundary_layer.map_to_local(cell)

func is_blocked_all_layers(cell) -> bool :
	if is_blocked(boundary_layer, cell):
		return true
	elif is_blocked(current_obstacle_layer, cell):
		if current_obstacle_layer == obstacle1_layer : 
			current_obstacle_layer = obstacle2_layer
		if current_obstacle_layer == obstacle2_layer : 
			current_obstacle_layer = obstacle1_layer
		if is_blocked(current_obstacle_layer, cell):
			return true
	return false

func is_blocked(layer: TileMapLayer, cell: Vector2i) -> bool:
	var data = layer.get_cell_tile_data(cell)
	if data:
		var is_astronaut = false
		if data.has_custom_data("is_astronaut"):
			is_astronaut = data.get_custom_data("is_astronaut")
		print(is_astronaut)
		if is_astronaut : win()
	return data != null

# --------------------------------------------------
# MOVEMENT
# --------------------------------------------------

func try_move(id : int, dir: Vector2i) -> void:
	if is_moving:
		return

	var current_cell = world_to_cell(global_position)
	var target_cell = current_cell + dir

	if is_blocked_all_layers(target_cell):
		EventBus.check_is_arrived.emit(id, false)
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
	EventBus.check_is_arrived.emit(id, true)

func should_fall() -> bool:

	var current = world_to_cell(global_position)
	var below = current + Vector2i.DOWN

	return not is_blocked_all_layers(below)
		
func fall():
	if is_moving:
		return

	var current = world_to_cell(global_position)
	var target = current

	# Cherche la dernière case libre
	while not is_blocked_all_layers(target + Vector2i.DOWN):
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
	await try_move(id, Vector2i.RIGHT)
	current_movement = MOVEMENT.GROUNDED

func on_move_left(id:int):
	await try_move(id, Vector2i.LEFT)
	current_movement = MOVEMENT.GROUNDED
	
func on_jump_right(id:int):
	await try_move(id, Vector2i(1, -1))
	current_movement = MOVEMENT.GROUNDED

func on_jump_left(id:int):
	await try_move(id, Vector2i(-1, -1))
	current_movement = MOVEMENT.GROUNDED
	
# --------------------------------------------------
# CHECKS
# --------------------------------------------------

func on_check_obj(id:int, offset: Vector2i):
	var current = world_to_cell(global_position)
	var side = current + offset
	await get_tree().process_frame
	EventBus.check_obj_response.emit(id, is_blocked(side))

## @deprecated
func on_check_obj_right(id:int):
	var current = world_to_cell(global_position)
	var side = current + Vector2i.RIGHT
	await get_tree().process_frame
	EventBus.check_obj_right_response.emit(id, is_blocked_all_layers(side))
	
## @deprecated
func on_check_obj_left(id:int):
	var current = world_to_cell(global_position)
	var side = current + Vector2i.LEFT
	await get_tree().process_frame
	EventBus.check_obj_left_response.emit(id, is_blocked_all_layers(side))
	
## @deprecated
func on_check_obj_under(id:int):
	var current = world_to_cell(global_position)
	var side = current + Vector2i.DOWN
	await get_tree().process_frame
	EventBus.check_obj_under_response.emit(id, is_blocked_all_layers(side))
	
func on_check_just_fell(id:int):
	var response = false
	if current_movement == MOVEMENT.FALLING:
		response = true
	EventBus.check_just_fell_response.emit(id, response)
		
func win():
	if level.unlock_level != "" :
		PreloadBus.resources["progression"][level.unlock_level] = true
	PreloadBus.change_level("win_menu")
