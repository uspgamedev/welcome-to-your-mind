extends KinematicBody

const MOVE_SPD = 0.05

onready var initial_trans = self.get_translation()
var player = null
var distance = 10
var i = 0
var vel

func _physics_process(delta):
	vel = Vector3((sin(i-1) * distance), 0, 0) - Vector3((sin(i) * distance), 0, 0)
	if player != null:
		player.plat_vel = vel
	self.set_translation(initial_trans + Vector3((sin(i) * distance), 0, 0))
	i += MOVE_SPD
	if (i > 2 * PI):
		i = 0

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		set_physics_process(true)

func _on_Area_body_exited(body):
	if player != null:
		player.plat_vel = Vector3(0, 0, 0)
	player = null
