extends KinematicBody

const norm_grav = -24.8
var vel = Vector3()
const MAX_SPEED = 20
const JUMP_SPEED = 18
const ACCEL = 3.5

var is_sprinting = false
var movement = "right"

onready var moveTween = get_node("MovementTween")

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

func _physics_process(delta):
    var dir = Vector3(0,0,0)

    if Input.is_action_pressed("movement_left"):
        dir.x += -1
        if movement == "right":
            print("BLU")
            movement = "left"
            moveTween.interpolate_property(get_node("MeshInstance"), "rotation_degrees", Vector3(0,0,0), Vector3(0,180,0), 0.30, moveTween.TRANS_LINEAR, moveTween.EASE_IN_OUT)
            moveTween.start()
            
    if Input.is_action_pressed("movement_right"):
        dir.x += 1
        if movement == "left":
            print("BLA")
            movement = "right"
            moveTween.interpolate_property(get_node("MeshInstance"), "rotation_degrees", Vector3(0,180,0), Vector3(0,0,0), 0.30, moveTween.TRANS_LINEAR, moveTween.EASE_IN_OUT)
            moveTween.start()

    if Input.is_action_pressed('ui_quit'):
        get_tree().quit()

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
