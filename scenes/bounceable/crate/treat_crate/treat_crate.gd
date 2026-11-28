@tool
class_name TreatCrate
extends Bounceable

@export_range(0, 5) var bounces := 4
@export_range(1, 3) var treats_per_bounce := 1

var _bounces_left: int


func _ready() -> void:
	_bounces_left = bounces


func hit() -> void:
	_give_treats()
	_register_bounce()


func destroy() -> void:
	queue_free()


func _register_bounce() -> void:
	if _bounces_left > 0:
		_bounce()
		_bounces_left -= 1
		return

	destroy()


func _give_treats() -> void:
	pass


func _on_hurtbox_3d_hit_taken(_hitbox: Hitbox3D) -> void:
	destroy()
