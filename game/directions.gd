extends Node

const UP = 0
const RIGHT = 1
const DOWN = 2
const LEFT = 3
const UP_RIGHT = 4
const DOWN_RIGHT = 5
const DOWN_LEFT = 6
const UP_LEFT = 7

var Vector = [Vector3(), Vector3(), Vector3(), Vector3(), \
              Vector3(), Vector3(), Vector3(), Vector3(), ]

func pov_update_vector(rot):
	if (rot.x > -1):
		Vector[UP] =    Vector3(-sin(rot.y), 0, -cos(rot.y))
		Vector[RIGHT] = Vector3(cos(rot.y), 0, -sin(rot.y))
		Vector[DOWN] =  Vector3(sin(rot.y), 0, cos(rot.y))
		Vector[LEFT] =  Vector3(-cos(rot.y), 0, sin(rot.y))
	else:
		Vector[UP] =     Vector3(sin(-rot.y), 0, cos(rot.y))
		Vector[RIGHT] =  Vector3(-cos(rot.y), 0, -sin(rot.y))
		Vector[DOWN] =   Vector3(-sin(-rot.y), 0, -cos(rot.y))
		Vector[LEFT] =   Vector3(cos(rot.y), 0, sin(rot.y))
	Vector[UP_RIGHT] =   sqrt(2)/2 * (Vector[UP] + Vector[RIGHT])
	Vector[DOWN_RIGHT] = sqrt(2)/2 * (Vector[DOWN] + Vector[RIGHT])
	Vector[DOWN_LEFT] =  sqrt(2)/2 * (Vector[DOWN] + Vector[LEFT])
	Vector[UP_LEFT] =    sqrt(2)/2 * (Vector[UP] + Vector[LEFT])

func side_update_vector():
	var rot = Vector2(0, 0)
	Vector[UP] =         Vector3(-cos(rot.y), 0, sin(rot.y))
	Vector[RIGHT] =      Vector3(-sin(rot.y), 0, -cos(rot.y))
	Vector[LEFT] =       Vector3(sin(rot.y), 0, cos(rot.y))
	Vector[DOWN] =       Vector3(cos(rot.y), 0, -sin(rot.y))
	Vector[UP_RIGHT] =   sqrt(2)/2 * (Vector[UP] + Vector[RIGHT])
	Vector[DOWN_RIGHT] = sqrt(2)/2 * (Vector[DOWN] + Vector[RIGHT])
	Vector[DOWN_LEFT] =  sqrt(2)/2 * (Vector[DOWN] + Vector[LEFT])
	Vector[UP_LEFT] =    sqrt(2)/2 * (Vector[UP] + Vector[LEFT])
