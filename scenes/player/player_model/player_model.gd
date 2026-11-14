class_name PlayerModel
extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get(
	"parameters/playback"
)


func idle() -> void:
	state_machine.travel(&"idle")


func walk() -> void:
	state_machine.travel(&"walk")


func jump() -> void:
	state_machine.travel(&"jump")


func fall() -> void:
	state_machine.travel(&"fall")
