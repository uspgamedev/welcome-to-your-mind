extends KinematicBody2D

export (bool)var evil = false

const SPD = 10000
const MINDISTANCE = 50
const MAXDISTANCE = 500

var target = null # if not null, Trigger is following target


func _ready():
	set_physics_process(false)
	set_process(false)
	set_process_input(false)

func _physics_process(delta):
	var target_pos = target.get_global_position()
	var velocity = (target_pos - self.global_position).normalized() * SPD * delta
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
	$DeathSFX.play()
	yield(AnimPlayer, "animation_finished")
	queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") and not target:
		target = body
		set_physics_process(true)

func _on_AreaCollision_body_entered(body):
	if not body.is_in_group("Player") and evil: # Evil triggers die when touching walls
		set_physics_process(false)
		get_node("Area2D").queue_free()
		get_node("AreaCollision").queue_free()
		die()
