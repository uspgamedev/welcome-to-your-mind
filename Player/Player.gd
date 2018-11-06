extends KinematicBody2D

export (String)var ReloadScene = "res://Stages/DepressionStage.tscn"

const GRAV = 2480
const ACCEL = 8
const AIR_ACCEL = 6
const MAX_SPD = 400
const JUMP_POWER = 850
const SHAKENUM = 3 # Times needed to shake before freeing itself from Triggers

var velocity = Vector2()
var direction = Vector2() # Input Direction
var can_jump = false
var last_shake = 0 # 0 is left, 1 is right. Used to force alternating directions in shake
var shake_counter = 0
var triggers = []

signal jumped

onready var timerbar = get_node("CanvasLayer/ProgressBar")

func ready():
	timerbar.value = 0

func get_input():
	direction = Vector2()
	if Input.is_action_pressed('ui_right'):
		direction.x += 1
		shake(1)
	elif Input.is_action_pressed('ui_left'):
		direction.x -= 1
		shake(0)
		
	if Input.is_action_pressed('ui_up') and can_jump and $JumpCooldown.time_left <= 0:
		jump()

func _process(delta):
	var timer = $DeathTimer 
	if not timer.is_stopped():
		timerbar.value = timer.wait_time - timer.time_left

func _physics_process(delta):
	get_input()
	
	var vel = Vector2(0, 0) # temporary velocity used for calculations
	vel.x = velocity.x
	if is_on_floor():
		vel = vel.linear_interpolate(direction * MAX_SPD, ACCEL * delta)
		vel.y = 0
	else:
		vel = vel.linear_interpolate(direction * MAX_SPD, AIR_ACCEL * delta)
		vel.y += delta * GRAV
	
	velocity.x = vel.x
	velocity.y += vel.y
	
	vel = move_and_slide(velocity, Vector2(0, -1))

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
		$DeathTimer.stop()
		timerbar.value = 0
		return
	var trig = triggers.pop_back()
	trig.shaked_off()

func add_trigger(trigger):
	var pos = trigger.get_global_position() - get_global_position()
	trigger.get_parent().remove_child(trigger)
	trigger.set_position(pos)
	add_child(trigger)
	triggers.append(trigger)
	if $DeathTimer.is_stopped():
		$DeathTimer.start()

func die():
	get_tree().change_scene(ReloadScene)

func _on_DeathTimer_timeout():
	self.die()

func get_jump():
	can_jump = true

func jump():
	velocity.y = -JUMP_POWER
	can_jump = false
	$SFXJump.play()
	$JumpCooldown.start()
	emit_signal("jumped")

