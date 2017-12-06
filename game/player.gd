extends 'res://body.gd'

const SENSITIVITY = 0.01

signal camera

onready var center = OS.get_window_size() / 2
onready var pov_camera = get_node('POVCamera')
onready var tp_camera = get_node('TPCamera')
onready var side_camera = get_node('../SideCamera')
onready var player_area = get_node('PlayerArea')
onready var animation = get_node('ze_movement/AnimationPlayer')

var animation_type = 'walk'
var acc = 3
var rot_x = 0
var encostinhos = [null, null, null]
var last_rot
var diff
var initial_rot

func _ready():
	set_fixed_process(true)
	input.connect('press_action', self, '_jump')
	input.connect('press_action', self, '_interact')
	input.connect('hold_action', self, '_add_jump_height')
	input.connect('hold_direction', self, '_add_speed')
	input.connect('press_direction', self, '_flip_body')
	input.connect('change_animation', self, '_change_animation')
	input.connect('press_action', self, '_change_camera')
	dir.pov_update_vector(self.get_rotation())
	set_process_input(true)
	get_viewport().warp_mouse(center)
	side_camera.make_current()
	initial_rot = self.get_rotation()
	self.connect('camera', self, '_side_camera_view')
	ACC = acc
	#for i in range (9):
	#	yield(get_tree(), 'fixed_frame')
	#self.connect('camera', self, '_check_mouse_rotation')

func _fixed_process(delta):
	emit_signal('camera')

func slow_down():
	ACC -= 1
	if (ACC < 1):
		die()

func speed_up():
	if (ACC < acc):
		ACC += 1

func die():
	get_tree().change_scene('res://main.tscn')

func _interact(act):
	if (act == ACT.INTERACT):
		for i in player_area.get_overlapping_areas():
			if i.is_in_group('interactable'):
				i.get_parent().interact()
				return

func _change_camera(act):
	if (act == ACT.SIDE_CAMERA and !tp_camera.is_current()):
		if (self.is_connected('camera', self, '_check_mouse_rotation')):
			self.disconnect('camera', self, '_check_mouse_rotation')
			self.connect('camera', self, '_side_camera_view')
			side_camera.make_current()
			self.set_rotation(initial_rot)
		else:
			self.connect('camera', self, '_check_mouse_rotation')
			self.disconnect('camera', self, '_side_camera_view')
			pov_camera.make_current()
	elif (act == ACT.TP_CAMERA and !side_camera.is_current()):
		rot_x = 0
		if (pov_camera.is_current()):
			tp_camera.set_rotation_deg(Vector3(-15, 0, 0))
			tp_camera.make_current()
		else:
			pov_camera.set_rotation_deg(Vector3(0, 0, 0))
			pov_camera.make_current()

func _side_camera_view():
	var body_trans = self.get_translation()
	side_camera.set_translation(Vector3(body_trans.x + 20, body_trans.y, body_trans.z))
	get_viewport().warp_mouse(center)
	dir.side_update_vector()

func _check_mouse_rotation():
	var new_mouse_pos = get_viewport().get_mouse_pos()
	diff = Vector2(0.1 * (new_mouse_pos.x - center.x), \
	(max(min(0.1 * (new_mouse_pos.y - center.y), 10), -10)))
	dir.pov_update_vector(self.get_rotation())
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
		self.global_rotate(Vector3(0, diff.x, 0), SENSITIVITY)
	get_viewport().warp_mouse(center)
	set_transform(self.get_transform().orthonormalized())

func _change_animation():
	var new_animation
	if (self.speed.z == 0):
		new_animation = 'idle'
	else:
		new_animation = 'walking'
	update_animation(new_animation)
	
func rotate():
	if (pov_camera.is_current()):
		rot_x -= diff.y * float(90)/157
		last_rot = pov_camera.get_rotation_deg().x
		pov_camera.rotate_x(0.01 * diff.y)
	else:
		rot_x -= diff.y * float(90)/157
		last_rot = tp_camera.get_rotation_deg().x
		tp_camera.rotate_x(0.003 * diff.y)
		# need to translate the camera around a sphere

func set_rotation_limit(limit):
	pov_camera.set_rotation_deg(Vector3(limit, \
	pov_camera.get_rotation_deg().y, pov_camera.get_rotation_deg().z))

func update_animation(new_animation):
	if (animation_type != new_animation):
		animation.play(new_animation)
		animation_type = new_animation