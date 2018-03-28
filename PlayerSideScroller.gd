extends KinematicBody

const norm_grav = -24.8
var vel = Vector3()
const MAX_SPEED = 20
const JUMP_SPEED = 18
const ACCEL = 3.5

var is_sprinting = false

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

func _physics_process(delta):
    var dir = Vector3(0,0,0)

    if Input.is_action_pressed("movement_left"):
        dir.x += -1
    if Input.is_action_pressed("movement_right"):
        dir.x += 1

    if is_on_floor():
        if Input.is_action_just_pressed("movement_jump"):
            vel.y = JUMP_SPEED

    dir.y = 0
    dir = dir.normalized()

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
