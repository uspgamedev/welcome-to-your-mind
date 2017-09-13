extends KinematicBody2D

const ACC = 32
const HORIZONTAL_VEL = 160
const VERTICAL_VEL = 0

var acc = ACC
var velocity = Vector2()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	motion_change(delta)
	
func motion_change(time_stamp):
	velocity.y = VERTICAL_VEL
	
	if(Input.is_action_pressed("ui_left")):
		velocity.x = -HORIZONTAL_VEL
	elif(Input.is_action_pressed("ui_right")):
		velocity.x = HORIZONTAL_VEL
	else:
		velocity.x = 0
		
	var motion = velocity * time_stamp
	move(motion)