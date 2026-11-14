class_name SceneConfig
extends Object

enum Scene {
	PLAYER,
}

const SCENE_UIDS := { Scene.PLAYER: "uid://coj7g664wteod" }


## Returns UID for [param scene].
static func get_scene_uid(scene: Scene) -> String:
	return SCENE_UIDS[scene]


## Returns instantiated [param scene].
static func get_packed_scene(scene: Scene) -> PackedScene:
	return load(SCENE_UIDS[scene])
