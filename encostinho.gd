extends KinematicBody

const NORM_GRAV = -24.8
const MAX_SLOPE_ANGLE = 40

var vel = Vector3(5, 0, 0)

func _on_Area_body_entered(body):
	if body.is_in_group('player'):
		body.encostinhos.append(self)
		body.encostinho_colision()

func _physics_process(delta):
	
	var grav = NORM_GRAV
	vel.y += delta*grav
	
	move_and_slide(vel)

func _on_Timer_timeout():
	vel.x *= -1
