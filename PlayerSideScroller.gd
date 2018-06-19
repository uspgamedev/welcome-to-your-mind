extends KinematicBody

var ladder_scn = preload("res://Ladder.tscn")
var mao_scn = preload("res://Mao.tscn")
const norm_grav = -24.8
var vel = Vector3()
var plat_vel = Vector3(0, 0, 0)
const MAX_SPEED = 20
const JUMP_SPEED = 18
const ACCEL = 3.5

var is_sprinting = false
var is_jumping = false
var carrying = false
var movement = "right"
var ladder = null
var encostinhos = []
var interact_counter = 0

onready var moveTween = get_node("MovementTween")
onready var mao_timer = get_node("MaoTimer")

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

func _input(event):
	var input_string = event.as_text().split(':')[0]
	if input_string != 'InputEventMouseMotion' and input_string != 'InputEventMouseButton':
		mao_timer.start()
	if event.is_action_pressed('interact'):
		interact_counter += 1
		if interact_counter % 5 == 0:
			interact_counter = 0
			if encostinhos.size() > 0:
				encostinho_left(encostinhos[encostinhos.size() -1])
	if event.is_action_pressed('interact') and ladder != null and is_on_floor():
		var lad
		for child in self.get_children():
			if child.is_in_group('ladder'):
				child.queue_free()
				lad = ladder_scn.instance()
				lad.translation = self.translation - Vector3(0, 1, 0)
				get_parent().add_child(lad)
				carrying = false
				return
		get_parent().remove_child(ladder)
		lad = ladder_scn.instance()
		carrying = true
		self.add_child(lad)

func encostinho_colision(encost):
	if (encostinhos.size() >= 3):
		die()
	encostinhos.append(encost)
	encost.set_translation(self.get_translation() + Vector3(1, 0, 0))
	encost.vel = Vector3(0, 0, 0)

func encostinho_left(encost):
	encostinhos.remove(encostinhos.find(encost))
	encost.vel = Vector3(5, 0, 0)
	encost.timer.start()
	encost.player = null
	encost.set_translation(Vector3(encost.get_translation().x, encost.init_pos.y, 0))

func _physics_process(delta):
	
	self.set_translation(Vector3(self.get_translation().x, self.get_translation().y, 0))
	
	var dir = Vector3(0,0,0)
	get_node("SideCamera").update_y()
	
	if Input.is_action_pressed("movement_left"):
		mao_timer.start()
		dir.x += -1
		if movement == "right":
			movement = "left"
			moveTween.interpolate_property(get_node("MeshInstance"), "rotation_degrees", Vector3(0,0,0), Vector3(0,180,0), 0.30, moveTween.TRANS_LINEAR, moveTween.EASE_IN_OUT)
			moveTween.start()
			
	elif Input.is_action_pressed("movement_right"):
		mao_timer.start()
		dir.x += 1
		if movement == "left":
			movement = "right"
			moveTween.interpolate_property(get_node("MeshInstance"), "rotation_degrees", Vector3(0,180,0), Vector3(0,0,0), 0.30, moveTween.TRANS_LINEAR, moveTween.EASE_IN_OUT)
			moveTween.start()
	
	elif Input.is_action_pressed('movement_forward') and ladder != null and not carrying:
		vel.y = 7
	
	if Input.is_action_pressed('ui_quit'):
		get_tree().quit()
	
	if is_on_floor():
		if is_jumping:
			is_jumping = false
		if Input.is_action_just_pressed("movement_jump"):
			vel.y = JUMP_SPEED
			is_jumping = true
	else:
		is_jumping = true
	
	dir.y = 0
	dir = dir.normalized()
	
	var grav = norm_grav
	vel.y += delta*grav
	
	var hvel = vel
	hvel.y = 0
	
	var target = dir
	var slow_factor = 1 + encostinhos.size() 
	target *= (MAX_SPEED/slow_factor)
	
	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel*delta)
	vel.x = hvel.x
	vel = move_and_slide(vel, Vector3(0,1,0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
	
	if self.get_floor_velocity() != Vector3(0, 0, 0):
		mao_timer.start()

func _on_MaoTimer_timeout():
	var mao = mao_scn.instance()
	mao.set_translation(self.get_translation() + Vector3(0, 0, 1))
	self.get_parent().add_child(mao)

func die():
	get_tree().change_scene("res://TestWorld.tscn")
