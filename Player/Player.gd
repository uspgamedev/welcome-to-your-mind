extends KinematicBody2D

export (float) var GRAV = 2480
const ACCEL = 5
const AIR_ACCEL = 2
const MAX_SPD = 400
const JUMP_POWER = 800

var velocity = Vector2()
var direction = Vector2() # Input Direction
var canJump = true


func get_input():
	direction = Vector2()
	if Input.is_action_pressed('ui_right'):
		direction.x += 1
	if Input.is_action_pressed('ui_left'):
		direction.x -= 1
	if Input.is_action_pressed('ui_up') and canJump and is_on_floor():
		velocity.y = -JUMP_POWER
#	direction = direction.normalized()


func _physics_process(delta):
	get_input()
	
	# Horizontal acceleration
	var hvel = Vector2(0, 0)
	hvel.x = velocity.x
	if is_on_floor():
		hvel = hvel.linear_interpolate(direction * MAX_SPD, ACCEL * delta)
	else:
		hvel = hvel.linear_interpolate(direction * MAX_SPD, AIR_ACCEL * delta)
	
	velocity.x = hvel.x
	velocity.y += delta * GRAV
	
	move_and_slide(velocity, Vector2(0, -1))
