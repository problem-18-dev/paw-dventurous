class_name Game
extends Node

@export_group("Debug")
@export var override_level: LevelConfig.Level

var _current_level: BaseLevel

@onready var level_root: Node3D = %LevelRoot
@onready var entity_root: Node3D = %EntityRoot
@onready var hud_root: Control = %HUDRoot
@onready var pause_root: Control = %PauseRoot
@onready var transition_root: Control = %TransitionRoot
@onready var debug_root: Control = %DebugRoot


func _ready() -> void:
	_load_systems()
	_load_level()
	_load_player()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"debug_quit"):
		get_tree().quit()


func _load_systems() -> void:
	pass


func _load_level() -> void:
	if _current_level:
		_current_level.queue_free()
		_current_level = null
		await get_tree().process_frame

	var level_to_load := override_level if override_level else LevelConfig.Level.LEVEL_ONE
	_current_level = LevelConfig.get_packed_level(level_to_load).instantiate()
	level_root.add_child(_current_level)


func _load_player() -> void:
	var spawn_position := _current_level.get_player_spawn_position()
	var player: Player = SceneConfig.get_packed_scene(SceneConfig.Scene.PLAYER).instantiate()
	entity_root.add_child(player)

	player.global_position = spawn_position
