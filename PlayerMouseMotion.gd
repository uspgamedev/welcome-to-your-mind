extends KinematicBody

const norm_grav = -24.8
var vel = Vector3()
const MAX_SPRINT_SPEED = 30
const MAX_SPEED = 20
const JUMP_SPEED = 18
const SPRINT_ACCEL = 18
const ACCEL = 3.5

var is_sprinting = false

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

var camera
var camera_holder

# You may need to adjust depending on the sensitivity of your mouse
const MOUSE_SENSITIVITY = 0.05

var flashlight

func _ready():
    camera = $Rotation_helper/Camera
    camera_holder = $Rotation_helper

    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

    flashlight = $Rotation_helper/Flashlight

func _physics_process(delta):
    var dir = Vector3()
    var cam_xform = camera.get_global_transform()

    if Input.is_action_pressed("movement_forward"):
        dir += -cam_xform.basis.z.normalized()
    if Input.is_action_pressed("movement_backward"):
        dir += cam_xform.basis.z.normalized()
    if Input.is_action_pressed("movement_left"):
        dir += -cam_xform.basis.x.normalized()
    if Input.is_action_pressed("movement_right"):
        dir += cam_xform.basis.x.normalized()

    if is_on_floor():
        if Input.is_action_just_pressed("movement_jump"):
            vel.y = JUMP_SPEED

    if Input.is_action_just_pressed("flashlight"):
            if flashlight.is_visible_in_tree():
                    flashlight.hide()
            else:
                    flashlight.show()

    if Input.is_action_pressed("movement_sprint"):
        is_sprinting = true
    else:
        is_sprinting = false

    dir.y = 0
    dir = dir.normalized()

    var grav = norm_grav
    vel.y += delta*grav

    var hvel = vel
    hvel.y = 0

    var target = dir
    if is_sprinting:
        target *= MAX_SPRINT_SPEED
    else:
        target *= MAX_SPEED

    var accel
    if dir.dot(hvel) > 0:
        if is_sprinting:
            accel = SPRINT_ACCEL
        else:
            accel = ACCEL
    else:
        accel = DEACCEL

    hvel = hvel.linear_interpolate(target, accel*delta)
    vel.x = hvel.x
    vel.z = hvel.z
    vel = move_and_slide(vel,Vector3(0,1,0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

    # (optional, but highly useful) Capturing/Freeing the cursor
    if Input.is_action_just_pressed("ui_cancel"):
        if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
        else:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
    if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        camera_holder.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
        self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

        var camera_rot = camera_holder.rotation_degrees
        camera_rot.x = clamp(camera_rot.x, -70, 70)
        camera_holder.rotation_degrees = camera_rot