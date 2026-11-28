@tool
class_name NormalCrate
extends Bounceable


func hit() -> void:
	destroy()


func destroy() -> void:
	queue_free()


func _on_hurtbox_3d_hit_taken(_hitbox: Hitbox3D) -> void:
	destroy()
