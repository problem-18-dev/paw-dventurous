class_name Crate
extends Destroyable


## Animates bounce.
func bounce() -> void:
	pass


## Calls [method destroy]
func hit() -> void:
	destroy()


## Animates destruction, and queue_free's the crate.
func destroy() -> void:
	Log.info("Crate destroyed!")
	queue_free()
