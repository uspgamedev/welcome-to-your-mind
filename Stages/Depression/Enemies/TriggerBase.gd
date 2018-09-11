extends KinematicBody2D

export (bool)var evil = false

const SPD = 10000
const MINDISTANCE = 50
const MAXDISTANCE = 500

var target = null # if not null, Trigger is following target

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	var target_pos = target.get_position()
	var velocity = (target_pos - self.position).normalized() * SPD * delta
	move_and_slide(velocity)
	
	if distance_to_target() < MINDISTANCE:
		reached_target(target)
	elif distance_to_target() > MAXDISTANCE:
		set_physics_process(false)
		target = null

func reached_target(target):
	set_physics_process(false)
	target = null

func distance_to_target():
	return get_position().distance_to(target.get_position())

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") and not target:
		target = body
		set_physics_process(true)