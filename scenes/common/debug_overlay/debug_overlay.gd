## Simple debug overlay to display the FPS and build version.
class_name DebugOverlay
extends Control

const BUILD_PROJECT_STRING := "application/config/version"
const FPS_TIMER_TIME := 0.2

@onready var _fps_label: Label = %FPSLabel
@onready var _build_label: Label = %BuildLabel


func _ready() -> void:
	_build_label.text += ProjectSettings.get_setting(BUILD_PROJECT_STRING)
	_update_fps()


func _update_fps() -> void:
	_fps_label.text = "FPS: %s" % Engine.get_frames_per_second()
	await get_tree().create_timer(FPS_TIMER_TIME, true, false, true).timeout
	_update_fps()
