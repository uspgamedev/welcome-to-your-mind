extends Node

const UP = 0
const RIGHT = 1
const DOWN = 2
const LEFT = 3
const UP_RIGHT = 4
const DOWN_RIGHT = 5
const DOWN_LEFT = 6
const UP_LEFT = 7

var Coordinates = [Vector3(), Vector3(), Vector3(), Vector3(), \
              Vector3(), Vector3(), Vector3(), Vector3(), ]

func pov_update_vector(rot):
	if (rot.x > -1):
		Coordinates[UP] =    Vector3(-sin(rot.y), 0, -cos(rot.y))
		Coordinates[RIGHT] = Vector3(cos(rot.y), 0, -sin(rot.y))
		Coordinates[DOWN] =  Vector3(sin(rot.y), 0, cos(rot.y))
		Coordinates[LEFT] =  Vector3(-cos(rot.y), 0, sin(rot.y))
	else:
		Coordinates[UP] =     Vector3(sin(-rot.y), 0, cos(rot.y))
		Coordinates[RIGHT] =  Vector3(-cos(rot.y), 0, -sin(rot.y))
		Coordinates[DOWN] =   Vector3(-sin(-rot.y), 0, -cos(rot.y))
		Coordinates[LEFT] =   Vector3(cos(rot.y), 0, sin(rot.y))
	Coordinates[UP_RIGHT] =   sqrt(2)/2 * (Coordinates[UP] + Coordinates[RIGHT])
	Coordinates[DOWN_RIGHT] = sqrt(2)/2 * (Coordinates[DOWN] + Coordinates[RIGHT])
	Coordinates[DOWN_LEFT] =  sqrt(2)/2 * (Coordinates[DOWN] + Coordinates[LEFT])
	Coordinates[UP_LEFT] =    sqrt(2)/2 * (Coordinates[UP] + Coordinates[LEFT])

func side_update_vector():
	var rot = Vector2(0, 0)
	Coordinates[UP] =         Vector3(0, 0, 0)
	Coordinates[RIGHT] =      Vector3(-sin(rot.y), 0, -cos(rot.y))
	Coordinates[LEFT] =       Vector3(sin(rot.y), 0, cos(rot.y))
	Coordinates[DOWN] =       Vector3(0, 0, 0)
	Coordinates[UP_RIGHT] =   sqrt(2)/2 * (Coordinates[UP] + Coordinates[RIGHT])
	Coordinates[DOWN_RIGHT] = sqrt(2)/2 * (Coordinates[DOWN] + Coordinates[RIGHT])
	Coordinates[DOWN_LEFT] =  sqrt(2)/2 * (Coordinates[DOWN] + Coordinates[LEFT])
	Coordinates[UP_LEFT] =    sqrt(2)/2 * (Coordinates[UP] + Coordinates[LEFT])
