@tool
class_name Enemy
extends CharacterBody3D

@export var data: EnemyResource:
	set(value):
		data = value
		update_configuration_warnings()

## Positions to loop between, if any.
var positions: Array[Vector3] = []
var previous_position_pointer := 0
var next_position_pointer := 0
var is_flipped := false

@onready var fsm: StateMachine = $StateMachine
@onready var shape: CollisionShape3D = $Shape
@onready var model: Node3D = $Model
@onready var turn_toward: TurnToward3D = $TurnToward3D
@onready var hitbox: Hitbox3D = $Hitbox3D
@onready var hitbox_shape: CollisionShape3D = $Hitbox3D/HitboxShape
@onready var hurtbox: Hurtbox3D = $Hurtbox3D
@onready var hurtbox_shape: CollisionShape3D = %HurtboxShape
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _get_configuration_warnings() -> PackedStringArray:
	var errors: PackedStringArray = []
	if find_children("*", "Marker3D").is_empty():
		errors.append("No patrol positions given. Add markers as a child. Order matters!")

	if not data:
		errors.append("No enemy data given.")

	return errors


func _ready() -> void:
	_apply_data()
	_debug_positions_top_level()

	if Engine.is_editor_hint():
		return

	_collect_positions()
	_initiate_pointer()
	fsm.change_state(EnemyTurn)


## Flips the enemy if can be flipped.
func flip() -> void:
	if not data.can_flip:
		return

	if is_flipped:
		animation_player.play(&"bounce")
		return

	fsm.change_state(FlippableEnemyFlipped)


## Returns [code]true[/code] enemy can be bounced off of.
func can_bounce() -> bool:
	return not is_flipped


## Returns [code]true[/code] if the enemy has more than two positions to loop between.
func can_move() -> bool:
	return not positions.is_empty() or positions.size() > 1


func _apply_data() -> void:
	if not data:
		return

	model.add_child(data.model.instantiate())
	shape.shape = data.shape
	shape.position = data.shape_offset

	# Hitbox
	hitbox.enabled = data.can_hit
	hitbox_shape.shape = data.hitbox_shape
	hitbox_shape.position = data.hitbox_offset

	# Hurtbox
	hurtbox.is_invincible = not data.can_hurt
	hurtbox_shape.shape = data.hurtbox_shape
	hurtbox_shape.position = data.hurtbox_offset


func _debug_positions_top_level() -> void:
	if not Engine.is_editor_hint():
		return

	var markers := find_children("*", "Marker3D")
	for marker: Marker3D in markers:
		marker.top_level = true


func _collect_positions() -> void:
	var markers := find_children("*", "Marker3D")
	for marker: Marker3D in markers:
		positions.push_front(marker.global_position)
		marker.queue_free()


func _initiate_pointer() -> void:
	if not can_move():
		return

	previous_position_pointer = positions.size() - 1 if data.patrol_reverse else 0
	next_position_pointer = positions.size() - 1 if data.patrol_reverse else 0


func _on_hurtbox_3d_hit_taken(hitbox_taken: Hitbox3D) -> void:
	fsm.change_state(EnemyDead, { "hitbox": hitbox_taken })
