extends Area

onready var cube = get_parent()
onready var initial_rot = get_rotation_deg()

func interact():
	if (cube.get_rotation_deg() == initial_rot):
		cube.set_rotation_deg(Vector3(0, 0, 45))
	else:
		cube.set_rotation_deg(initial_rot)