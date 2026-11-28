class_name FlippableEnemyFlipped
extends EnemyState


func enter(_data := { }) -> void:
	enemy.set_deferred(&"is_flipped", true)
	enemy.animation_player.play(&"flip")
	enemy.hitbox.enabled = false
