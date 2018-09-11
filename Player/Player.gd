extends KinematicBody2D

export (float) var GRAV = 2480
const ACCEL = 5
const AIR_ACCEL = 2
const MAX_SPD = 400
const JUMP_POWER = 800
const SHAKENUM = 3 # Times needed to shake before freeing itself from Triggers

var velocity = Vector2()
var direction = Vector2() # Input Direction
var can_jump = true
var last_shake = 0 # 0 is left, 1 is right. Used to force alternating directions in shake
var shake_counter = 0
var triggers = []


func get_input():
	direction = Vector2()
	if Input.is_action_pressed('ui_right'):
		direction.x += 1
		shake(1)
	elif Input.is_action_pressed('ui_left'):
		direction.x -= 1
		shake(0)
		
	if Input.is_action_pressed('ui_up') and can_jump and is_on_floor():
		velocity.y = -JUMP_POWER


func _physics_process(delta):
	get_input()
	
	# Horizontal acceleration
	var hvel = Vector2(0, 0)
	hvel.x = velocity.x
	if is_on_floor():
		hvel = hvel.linear_interpolate(direction * MAX_SPD, ACCEL * delta)
	else:
		hvel = hvel.linear_interpolate(direction * MAX_SPD, AIR_ACCEL * delta)
	
	velocity.x = hvel.x
	velocity.y += delta * GRAV
	
	move_and_slide(velocity, Vector2(0, -1))


func shake(shake_direction):
	if shake_direction == last_shake:
		return
	last_shake = shake_direction
	$ShakeTimer.start()
	shake_counter += 1
	if shake_counter >= SHAKENUM:
		free_trigger()

func _on_ShakeTimer_timeout():
	shake_counter = 0

func free_trigger():
	shake_counter = 0
	if triggers.empty():
		return
	var trig = triggers.pop_back()
	print("Player: ", get_global_position())
	print("Trig: ", trig.get_global_position())
	trig.shaked_off()

func add_trigger(trigger):
	var pos = trigger.get_position() - get_position()
	get_parent().remove_child(trigger)
	trigger.set_position(pos)
	add_child(trigger)
	triggers.append(trigger)
