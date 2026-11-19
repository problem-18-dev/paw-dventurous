class_name Crate
extends Destroyable

@onready var animation_player: AnimationPlayer = $AnimationPlayer


## Animates bounce.
func bounce() -> void:
	animation_player.play(&"bounce")


## Calls [method destroy]
func hit() -> void:
	destroy()


## Animates destruction, and queue_free's the crate.
func destroy() -> void:
	Log.info("Crate destroyed!")
	queue_free()
