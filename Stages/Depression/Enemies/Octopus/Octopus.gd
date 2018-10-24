extends Node2D

export (PackedScene)var TriggerWave = null

const SPEED_MULTIPLIER = 1
const ATK_OFFSET = 40
const ATK_SPEED = 700
const ANGLE_MULTIPLIER = 2.2

onready var initialy = get_global_position().y
var Target

var angle = -1.4

func ready():
	set_physics_process(false)
	set_process(false)
	set_process_input(false)

func _physics_process(delta):
	if Target:
		follow(Target, delta)

func activate(Target):
	self.Target = Target
	set_physics_process(true)
	start_attacking(Target)

func deactivate():
	Target = get_parent().get_node("CameraAdjust") # used to Octopus goes away after being deactivated
	$AttackInterval.stop()
	$AttackDuration.stop()
	$AnimationPlayer.stop()
	
	$FXAudioPlayer/Tween.interpolate_property($FXAudioPlayer, "volume_db", 0, -40, $AttackCooldown.wait_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$FXAudioPlayer/Tween.start()
	
	$AttackCooldown.start()
	yield($AttackCooldown, "timeout")
	queue_free()

func follow(Target, delta):
	var dist = get_global_position() - Target.get_global_position()
	var direction = Vector2(1, 0)
	if dist.x > 0:
		direction = Vector2(-1, 0)
	var speed = abs(dist.x) * SPEED_MULTIPLIER
	speed = clamp(speed, 0.0, 400.0)
	var velocity = direction * speed * delta
	set_position(get_position() + velocity)
	angle = (get_global_position() + Vector2(0, ATK_OFFSET)).angle_to_point(Target.get_global_position())
	$Sprite.set_rotation_degrees(cos(angle) * 10 * ANGLE_MULTIPLIER)

func start_attacking(Target):
	$AttackDuration.start()
	$AnimationPlayer.play("Attacking")
	$FXAudioPlayer.play()
	attack(Target)

func attack(Target):
	$AttackInterval.start()
	var vec_angle = Vector2(-cos(angle) * ANGLE_MULTIPLIER, -sin(angle))
	var pos = get_position() + Vector2(0, ATK_OFFSET)
	var TrigWv = TriggerWave.instance()
	TrigWv.DIRECTION = vec_angle
	TrigWv.SPEED = ATK_SPEED
	TrigWv.set_position(pos)
	get_parent().add_child(TrigWv)

func _on_AttackCooldown_timeout():
	start_attacking(Target)

func _on_AttackInterval_timeout():
	if not $AttackDuration.is_stopped():
		attack(Target)

func _on_AttackDuration_timeout():
	$AttackCooldown.start()
	$AnimationPlayer.play("Charging")
