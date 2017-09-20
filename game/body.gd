extends KinematicBody

const ACT = preload("actions.gd")
const G = -160
const ACC = 2.2
const EPSILON = 1

onready var center = OS.get_window_size() / 2
onready var input = get_node('/root/input')
onready var dir = get_node('/root/directions')
onready var camera = get_node('Camera')
onready var rot_x = 0

var speed = Vector3()
var normal
var motion
var can_jump
var jump_height = -1
var last_rot
var diff

func _ready():
	set_fixed_process(true)
	input.connect('press_action', self, '_jump')
	input.connect('hold_action', self, '_add_jump_height')
	input.connect('hold_direction', self, '_add_speed')
	get_viewport().warp_mouse(center)
	dir.update_vector(self.get_rotation())
	set_process_input(true)

func _fixed_process(delta):
	apply_gravity(delta)
	apply_speed(delta)
	deaccelerate()
	check_mouse_rotation()
	dir.update_vector(self.get_rotation())

func set_jump(flag):
	self.can_jump = flag

func _jump(act):
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
	self.speed += dir.Vector[direction] * ACC

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
	if (collider extends GridMap and normal.y == 1):
		set_jump(true)
		jump_height = -1

func deaccelerate():
	if (speed.length_squared() < EPSILON):
		speed.x = 0
		speed.z = 0
	else:
		speed.x *= .8
		speed.z *= .8
	speed.y *= .85

func check_mouse_rotation():
	var new_mouse_pos = get_viewport().get_mouse_pos()
	diff = Vector2(0.1 * (new_mouse_pos.x - center.x), \
	(max(min(0.1 * (new_mouse_pos.y - center.y), 10), -10)))
	if (diff != Vector2(0, 0)):
		if (diff.y < 0):
			if (rot_x < 90):
				rotate()
			else:
				set_rotation_limit(90)
		elif (diff.y > 0):
			if (rot_x > -90):
				rotate()
			else:
				set_rotation_limit(-90)
		self.global_rotate(Vector3(0, diff.x, 0), 0.008)
	get_viewport().warp_mouse(center)
	set_transform(self.get_transform().orthonormalized())

func rotate():
	rot_x -= diff.y * float(90)/157
	last_rot = camera.get_rotation_deg().x
	camera.rotate_x(0.01 * diff.y)

func set_rotation_limit(limit):
	camera.set_rotation_deg(Vector3(limit, \
	camera.get_rotation_deg().y, camera.get_rotation_deg().z))
