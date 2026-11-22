class_name PlayerModel
extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get(
	"parameters/Locomotion/playback"
)


func idle() -> void:
	state_machine.travel(&"idle")


func walk() -> void:
	state_machine.travel(&"walk")


func jump() -> void:
	state_machine.travel(&"jump")


func fall() -> void:
	state_machine.travel(&"fall")


func attack() -> void:
	animation_tree.set("parameters/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func die() -> void:
	state_machine.travel(&"die")
