class_name LevelConfig
extends Object

enum Level {
	LEVEL_ONE,
}

const LEVEL_UIDS := { Level.LEVEL_ONE: "uid://cp00sg7wweix1" }


## Returns UID for [param level].
static func get_level_uid(level: Level) -> String:
	return LEVEL_UIDS[level]


## Returns instantiated [param level].
static func get_packed_level(level: Level) -> PackedScene:
	return load(LEVEL_UIDS[level])
