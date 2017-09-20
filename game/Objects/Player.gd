extends KinematicBody2D

const ACC = 32
const HORIZONTAL_VEL = 160
const VERTICAL_VEL = 0
const GRAVITY = 200

var acc = ACC
var velocity = Vector2()
var jumping = false

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	motion_change(delta)

func is_on_floor():
	#CADÊ?
	return true

func motion_change(time_stamp):
	#velocity.y = VERTICAL_VEL
	
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_pressed("ui_jump")
	
	if(left):
		velocity.x = -HORIZONTAL_VEL
	elif(right):
		velocity.x = HORIZONTAL_VEL
	else:
		velocity.x = 0
	
	if(jump):
		if(!jumping and is_on_floor()):
			jumping = true
			velocity.y = -2000
			
	if(jumping):
		velocity.y = velocity.y + GRAVITY
		if(velocity.y == 2000):
			jumping = false
			velocity.y = 0

	
	var motion = velocity * time_stamp
	move(motion)