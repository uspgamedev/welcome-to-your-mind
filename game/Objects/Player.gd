extends KinematicBody2D

const ACC = 32
const HORIZONTAL_VEL = 320
const VERTICAL_VEL = 0
const GRAVITY = 200
const JUMP_SPEED = -2000

var acc = ACC
var velocity = Vector2()
var jumping = 0  # 0 = parado. 1 = 1o pulo. 2 = 2o pulo.

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	motion_change(delta)
	

func is_on_floor():
	if(is_colliding()):
		var collider = get_collider()
		if (collider.get_type() == "TileMap"):
			var n = get_collision_normal()
			if (n.x == 0 and n.y == -1):
				return true
	return false

func motion_change(time_stamp):
	#velocity.y = VERTICAL_VEL
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y = velocity.y + GRAVITY

	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var jump_action = Input.is_action_pressed("ui_jump")
	
	if(left):
		velocity.x = -HORIZONTAL_VEL
	elif(right):
		velocity.x = HORIZONTAL_VEL
	else:
		velocity.x = 0
	
	if(jump_action):
		if(jumping != 2):
			jumping += 1
			velocity.y = JUMP_SPEED

	if(jumping > 0):
		#Se colidir com algum objeto ou plataforma, ele para de "pular"
		if(is_on_floor()):
			jumping = 0
			velocity.y = 0
	
	var motion = velocity * time_stamp
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
	move(motion)