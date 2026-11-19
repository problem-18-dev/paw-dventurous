@abstract
class_name Destroyable
extends StaticBody3D


func _init() -> void:
	add_to_group(GroupConfig.DESTROYABLE)


## Animates bounce.
@abstract func bounce() -> void


## Executes the on-hit logic for the [Destroyable].
@abstract func hit() -> void


## Executes destruction and frees [Destroyable].
@abstract func destroy() -> void
