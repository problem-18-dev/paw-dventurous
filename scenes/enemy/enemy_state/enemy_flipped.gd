class_name EnemyFlipped
extends EnemyState


func enter(_data := { }) -> void:
	enemy.is_flipped = true
	enemy.animation_player.play(&"flip")
	enemy.hitbox.enabled = false
