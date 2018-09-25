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
	
	var dist = distance_to_target()
	if  dist < MINDISTANCE:
		reached_target(target)
	elif dist > MAXDISTANCE:
		set_physics_process(false)
		target = null

func reached_target(target):
	set_physics_process(false)
	target = null

func distance_to_target():
	return get_global_position().distance_to(target.get_global_position())

func die():
	var AnimPlayer = $Sprite/AnimationPlayer
	AnimPlayer.play("die")
	yield(AnimPlayer, "animation_finished")
	queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") and not target:
		target = body
		set_physics_process(true)
	elif body.is_in_group("Floor") and get_parent().is_in_group("TriggerWave"):
		get_node("Area2D").queue_free()
		die()