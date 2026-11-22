extends Node3D

@onready var player: Player = $Player
@onready var die_button: Button = %DieButton


func _on_die_button_pressed() -> void:
	player.fsm.change_state(PlayerDead)
	player.camera.disable()
	die_button.disabled = true


func _on_reset_button_pressed() -> void:
	get_tree().reload_current_scene()
