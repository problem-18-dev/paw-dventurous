class_name EnemyResource
extends Resource

const DEFAULT_PATROL_SPEED := 3.0

## Model scene to instantiate.
@export var model: PackedScene
## Collision shape
@export var shape: Shape3D
## The position offset of the collision shape.
@export var shape_offset: Vector3
@export_group("Patrol")
## How quickly the enemy moves between positions.
@export var patrol_speed := DEFAULT_PATROL_SPEED
## If [code]true[/code], the enemy will move in reverse order.
@export var patrol_reverse := false
@export_group("Flip")
## If [code]true[/code], the enemy can be flipped when jumped on.
@export var can_flip := false
@export_group("Hurtbox")
## If [code]true[/code], the enemy can be hurt by the player.
@export var can_hurt := false
## Shape of the enemy's [Hurtbox3D].
@export var hurtbox_shape: Shape3D
## The position offset of the [Hurtbox3D] shape
@export var hurtbox_offset: Vector3
@export_group("Hitbox")
## If [code]true[/code], the enemy can hit the player.
@export var can_hit := true
## Shape of the enemy's [Hitbox3D].
@export var hitbox_shape: Shape3D
## The position offset of the [Hitbox3D] shape
@export var hitbox_offset: Vector3
