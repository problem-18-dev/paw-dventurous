## A flippable enemy can be flipped when jumped on top of it. It can also be killed with an attack.
@tool
class_name FlippableEnemy
extends Enemy

var is_flipped := false

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func flip() -> void:
	if is_flipped:
		animation_player.play(&"bounce")
		return

	fsm.change_state(EnemyFlipped)


func _on_hurtbox_3d_hit_taken(hitbox_taken: Hitbox3D) -> void:
	fsm.change_state(EnemyDead, { "hitbox": hitbox_taken })
