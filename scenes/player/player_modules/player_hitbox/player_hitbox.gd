@tool
class_name PlayerHitbox
extends Hitbox3D

var _overlapping_areas: Array[Node3D] = []


func enable() -> void:
	super()
	_hit_overlapping_areas()


func _hit_overlapping_areas() -> void:
	for area: Hurtbox3D in _overlapping_areas:
		area.take_hit(self)

	_overlapping_areas.clear()


func _on_area_entered(hurtbox: Hurtbox3D) -> void:
	if not enabled and not _overlapping_areas.has(hurtbox):
		_overlapping_areas.append(hurtbox)
		return

	hurtbox.take_hit(self)
	hit.emit(hurtbox)


func _on_area_exited(area: Area3D) -> void:
	if not _overlapping_areas.has(area):
		return

	_overlapping_areas.erase(area)
