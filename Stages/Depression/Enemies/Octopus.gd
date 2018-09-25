extends Node2D

export (NodePath)var targetpath = null
export (PackedScene)var TriggerWave = null

const SPEED_MULTIPLIER = 1
const ATK_OFFSET = 40
const ATK_SPEED = 700

onready var Target = get_parent().get_node("Player")
onready var initialy = get_global_position().y

func _physics_process(delta):
	follow(Target, delta)

func follow(Target, delta):
	var dist = get_global_position() - Target.get_global_position()
	var direction = Vector2(1, 0)
	if dist.x > 0:
		direction = Vector2(-1, 0)
	var speed = abs(dist.x) * SPEED_MULTIPLIER
	var velocity = direction * speed * delta
	set_position(get_position() + velocity)

func start_attacking(Target):
	$AttackDuration.start()
	attack(Target)

func attack(Target):
	$AttackInterval.start()
	
	var dir = (get_global_position() + Vector2(0, ATK_OFFSET)).angle_to_point(Target.get_global_position())
	var angle = Vector2(-cos(dir), -sin(dir))
	var pos = get_position() + Vector2(0, ATK_OFFSET)
	var TrigWv = TriggerWave.instance()
	TrigWv.DIRECTION = angle
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
