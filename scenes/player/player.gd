class_name Player
extends CharacterBody3D

@onready var fsm: StateMachine = $StateMachine
@onready var shape: CollisionShape3D = $Shape
@onready var model: PlayerModel = $Model
@onready var hurtbox: Hurtbox3D = $Hurtbox3D
@onready var hitbox: Hitbox3D = $Hitbox3D
@onready var attack_module: PlayerAttackModule = %AttackModule
@onready var invincibility_module: PlayerInvinciblityModule = %InvincibilityModule
@onready var flicker: Flicker = %FlickerModule
@onready var turn_toward: TurnToward3D = %TurnToward
@onready var jump_input_buffer: InputBuffer = $JumpInputBuffer


func _init() -> void:
	add_to_group(GroupConfig.PLAYER)


func _ready() -> void:
	fsm.change_state(PlayerAirFall)


## Makes player walk towards a certain destination, and enter finish state.
func finish_at(destination: Vector3) -> void:
	fsm.change_state(PlayerFinish, { "destination": destination })


func _on_player_attack_module_attack_requested() -> void:
	model.attack()
	hitbox.enable()


func _on_hurtbox_3d_hit_taken(hitbox_taken: Hitbox3D) -> void:
	fsm.change_state(PlayerHurt, { "hitbox": hitbox_taken })


func _on_invincibility_module_finished() -> void:
	flicker.disable()


func _on_attack_module_finished() -> void:
	hitbox.disable()
