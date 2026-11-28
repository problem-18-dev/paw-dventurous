@tool
@abstract
class_name Bounceable
extends PhysicsBody3D

const DEFAULT_BOUNCE_OFFSET := Vector3(0.2, -0.2, 0.2)

## Bounce offset for the tween. Positive values enlarge, negative values shrink.
@export var bounce_offset := DEFAULT_BOUNCE_OFFSET
## The total duration of the bounce tween.
@export var bounce_duration := 0.2
@export var bounce_ease: Tween.EaseType
@export var bounce_trans: Tween.TransitionType
@export_tool_button("Bounce") var bounce_action: Callable = _bounce

var _bounce_tween: Tween

@onready var _mesh: MeshInstance3D = $Mesh


func _init() -> void:
	add_to_group(GroupConfig.BOUNCEABLE)


## Returns [code]true[/code] if bouncing can happen.
func can_bounce() -> bool:
	return true


func _bounce() -> void:
	if _bounce_tween:
		_bounce_tween.kill()

	var base_scale := _mesh.scale
	var target_scale := _mesh.scale + bounce_offset
	_bounce_tween = create_tween().set_ease(bounce_ease).set_trans(bounce_trans)
	_bounce_tween.tween_property(_mesh, "scale", target_scale, bounce_duration / 2)
	_bounce_tween.tween_property(_mesh, "scale", base_scale, bounce_duration / 2)


## Executes the on-hit logic for the [Bounceable], like jumping on top.
@abstract func hit() -> void


## Executes destruction and frees [Bounceable], like when attacked.
@abstract func destroy() -> void
