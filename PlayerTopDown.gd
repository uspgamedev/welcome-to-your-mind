extends KinematicBody

const norm_grav = -24.8
var vel = Vector3()
const MAX_SPEED = 20
const JUMP_SPEED = 18
const ACCEL = 3.5

var is_sprinting = false
var movement = "foward"
var old_dir = Vector3(0, 0, -1)

onready var moveTween = get_node("MovementTween")

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

func _physics_process(delta):
	var dir = Vector3(0,0,0)
	
	if Input.is_action_pressed("movement_left"):
		dir.x = -1
	elif Input.is_action_pressed("movement_right"):
		dir.x = 1
	
	if Input.is_action_pressed("movement_forward"):
		dir.z = -1
	elif Input.is_action_pressed("movement_backward"):
		dir.z = 1
	
	if Input.is_action_pressed('ui_quit'):
		get_tree().quit()
	
	dir.y = 0
	dir = dir.normalized()
	
	if dir != Vector3(0, 0, 0) and dir != old_dir:
		var angle = rad2deg(old_dir.angle_to(dir))
		var cross = old_dir.cross(dir)
		var old_rot = get_rotation_degrees()
		
		if cross.y < 0.5:
			angle = -angle
		
		old_dir = dir
		moveTween.interpolate_property(get_node("MeshInstance"), "rotation_degrees", old_rot, Vector3(0,angle,0), 0.30, moveTween.TRANS_LINEAR, moveTween.EASE_IN_OUT)
		moveTween.start()
	
	
	var grav = norm_grav
	vel.y += delta*grav
	
	var hvel = vel
	hvel.y = 0
	
	var target = dir
	target *= MAX_SPEED
	
	var accel
	if dir.dot(hvel) > 0:
	    accel = ACCEL
	else:
	    accel = DEACCEL
	
	hvel = hvel.linear_interpolate(target, accel*delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel,Vector3(0,1,0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
