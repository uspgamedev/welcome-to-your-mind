extends KinematicBody2D

export (float) var GRAV = 2480
const ACCEL = 3.5
const MAX_SPD = 400

var velocity = Vector2()
var direction = Vector2()


func get_input():
	direction = Vector2()
	if Input.is_action_pressed('ui_right'):
		direction.x += 1
	if Input.is_action_pressed('ui_left'):
		direction.x -= 1
	direction = direction.normalized()

func _physics_process(delta):
	get_input()
	var hvel = velocity
	hvel.y = 0
	hvel = hvel.linear_interpolate(direction * MAX_SPD, ACCEL * delta)
	
	velocity.x = hvel.x
	velocity.y += delta * GRAV
	
	move_and_slide(velocity)
