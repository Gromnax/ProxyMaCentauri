extends Node2D

@onready var boundary_layer : TileMapLayer = $"../BoundaryLayer"
@onready var obstacle1_layer : TileMapLayer = $"../Obstacle1Layer"
@onready var obstacle2_layer : TileMapLayer = $"../Obstacle2Layer"
var collision_layers = [boundary_layer, obstacle1_layer, obstacle2_layer]
@onready var current_obstacle_layer : TileMapLayer = obstacle1_layer

@onready var level = $".."

const TILE_SIZE := 32
const MOVE_TIME := 0.3
const JUMP_HEIGHT := 64

enum MOVEMENT {
	FALLING,
	GROUNDED
}

signal fall_finished

var current_movement := MOVEMENT.GROUNDED
var is_moving := false
var ignore_fall := false

func _ready() -> void:
	EventBus.move_left.connect(on_move_left)
	EventBus.move_right.connect(on_move_right)
	EventBus.jump_left.connect(on_jump_left)
	EventBus.jump_right.connect(on_jump_right)
	EventBus.check_obj.connect(on_check_obj)
	EventBus.check_just_fell.connect(on_check_just_fell)
	
func _process(delta: float) -> void:
	if not is_moving and should_fall() and not ignore_fall:
		fall()

# --------------------------------------------------
# GRID HELPERS
# --------------------------------------------------

func world_to_cell(pos: Vector2) -> Vector2i:
	return boundary_layer.local_to_map(pos)

func cell_to_world(cell: Vector2i) -> Vector2:
	return boundary_layer.map_to_local(cell)

func is_blocked_all_layers(cell: Vector2i) -> bool:
	return is_blocked(boundary_layer, cell) \
		or is_blocked(obstacle1_layer, cell) \
		or is_blocked(obstacle2_layer, cell)

func is_blocked(layer: TileMapLayer, cell: Vector2i) -> bool:
	var data = layer.get_cell_tile_data(cell)
	if data:
		var is_astronaut = false
		if data.has_custom_data("is_astronaut"):
			is_astronaut = data.get_custom_data("is_astronaut")
		if is_astronaut : win()
	return data != null

# --------------------------------------------------
# MOVEMENT
# --------------------------------------------------

func try_move(id : int, dir: Vector2i) -> void:
	if is_moving:
		return

	var current_cell = world_to_cell(global_position)

	# Les sauts diagonaux restent sur 1 case
	var max_distance := 1

	# Les déplacements horizontaux peuvent aller jusqu'à 3 cases
	if dir.y == 0:
		max_distance = 3

	var move_distance := 0

	for i in range(1, max_distance + 1):
		var test_cell = current_cell + dir * i

		# Collision
		if is_blocked_all_layers(test_cell):
			break

		# Pour les déplacements horizontaux :
		# il faut un sol sous la case
		if dir.y == 0:
			var below = test_cell + Vector2i.DOWN

			if should_fall():
				break

		move_distance = i

	# Aucun déplacement possible
	if move_distance == 0:
		print("impossible", id)
		EventBus.check_is_arrived.emit(id, false)
		return

	is_moving = true

	var target_cell = current_cell + dir * move_distance
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

	# Déclenche immédiatement la chute si nécessaire
	if should_fall():
		await fall()

	EventBus.check_is_arrived.emit(id, true)

func should_fall() -> bool:
	var current = world_to_cell(global_position)
	var below = current + Vector2i.DOWN

	return not is_blocked_all_layers(below)
		
func fall() -> void:
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
	current_movement = MOVEMENT.GROUNDED

	fall_finished.emit()
# --------------------------------------------------
# ACTIONS
# --------------------------------------------------

func on_move_right(id:int):
	$AnimatedSprite2D.scale.x = 1
	AudioBus.play_sfx(PreloadBus.sfx["step1"])
	$AnimatedSprite2D.play("run")
	await try_move(id, Vector2i.RIGHT)
	current_movement = MOVEMENT.GROUNDED
	

func on_move_left(id:int):
	AudioBus.play_sfx(PreloadBus.sfx["step1"])
	$AnimatedSprite2D.scale.x = -1
	$AnimatedSprite2D.play("run")
	await try_move(id, Vector2i.LEFT)
	current_movement = MOVEMENT.GROUNDED
	
	
func on_jump_right(id:int):
	AudioBus.play_sfx(PreloadBus.sfx["jump"])
	$AnimatedSprite2D.scale.x = 1
	$AnimatedSprite2D.play("run")
	await try_move(id, Vector2i(1, -1))
	current_movement = MOVEMENT.GROUNDED
	

func on_jump_left(id:int):
	AudioBus.play_sfx(PreloadBus.sfx["jump"])
	$AnimatedSprite2D.scale.x = -1
	$AnimatedSprite2D.play("run")
	await try_move(id, Vector2i(-1, -1))
	current_movement = MOVEMENT.GROUNDED
	
	
# --------------------------------------------------
# CHECKS
# --------------------------------------------------

func on_check_obj(id:int, offset: Vector2i):
	var current = world_to_cell(global_position)
	var side = current + offset
	await get_tree().process_frame
	EventBus.check_obj_response.emit(id, is_blocked_all_layers(side))

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
