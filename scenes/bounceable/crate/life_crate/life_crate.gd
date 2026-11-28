@tool
class_name LifeCrate
extends Bounceable


func hit() -> void:
	_drop_life()
	destroy()


func destroy() -> void:
	queue_free()


func _drop_life() -> void:
	pass


func _on_hurtbox_3d_hit_taken(_hitbox: Hitbox3D) -> void:
	destroy()
