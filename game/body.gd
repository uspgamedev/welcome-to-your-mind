extends KinematicBody

const ACT = preload('actions.gd')
const DIR = preload('directions.gd')
const G = -160
const ACC = 1.6
const EPSILON = 1

onready var input = get_node('/root/input')
onready var dir = get_node('/root/directions')

var speed = Vector3()
var normal
var motion
var can_jump
var jump_height = -1

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	apply_gravity(delta)
	apply_speed(delta)
	deaccelerate()

func set_jump(flag):
	self.can_jump = flag

func _flip_body(dir):
	if (dir == DIR.RIGHT):
		self.set_rotation_deg(Vector3(0, 0, 0))
	elif (dir == DIR.LEFT):
		self.set_rotation_deg(Vector3(-180, 0, -180))

func _jump(act):
	if (act == ACT.JUMP):
		if (jump_height >= 0):
			jump_height = -1
		if (can_jump and act == ACT.JUMP):
			speed -= Vector3(0, .05 * G, 0)
			jump_height = 0
		set_jump(false)

func _add_jump_height(act):
	if (speed.y < EPSILON and speed.y > -EPSILON):
		jump_height = -1
	if (act == ACT.JUMP and jump_height >= 0 and jump_height < 7):
		speed -= Vector3(0, 0.05 * G, 0)
		jump_height += 1

func _add_speed(direction):
	self.speed += dir.Coordinates[direction] * ACC

func apply_gravity(delta):
	speed.y += delta * G

func apply_speed(delta):
	var motion = move(self.speed * delta)
	if (self.is_colliding()):
		var collider = self.get_collider()
		normal = get_collision_normal()
		check_if_floor(collider, normal)
		motion = 0.018 * normal.slide(self.speed)
		move(motion)
	else:
		set_jump(false)
	if (can_jump and jump_height == -1):
		speed.y = 0

func check_if_floor(collider, normal):
	if (normal.y == 1):
		speed.y = 0
	if (normal.y == 1):
		set_jump(true)
		jump_height = -1

func deaccelerate():
	if (speed.length_squared() < EPSILON):
		speed.x = 0
		speed.z = 0
	else:
		speed.x *= .6
		speed.z *= .6
	speed.y *= .85
