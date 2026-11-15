class_name GameConfig
extends Object

enum PickuppableType {
	DOG_TREAT,
	TENNIS_BALL,
}

const PICKUPPABLE_UIDS := {
	PickuppableType.DOG_TREAT: "uid://cwu5imt73klx3",
	PickuppableType.TENNIS_BALL: "uid://cy0r34nqlorpw",
}


static func get_pickuppable_data(type: GameConfig.PickuppableType) -> PickuppableResource:
	return load(PICKUPPABLE_UIDS[type])
