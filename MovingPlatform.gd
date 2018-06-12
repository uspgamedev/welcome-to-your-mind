extends KinematicBody

const MOVE_SPD = 0.05

onready var initial_trans = self.get_translation()
var player = null
var distance = 2
var i = 0
var vel

func _physics_process(delta):
	if player != null:
		player.plat_vel = vel
	self.set_translation(initial_trans + Vector3(i*distance, 0, 0))
	i += MOVE_SPD
	if (abs(i) > 2 * PI):
		i = 0
		initial_trans = self.get_translation()
		MOVE_SPD *= -1

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		set_physics_process(true)

func _on_Area_body_exited(body):
	if player != null:
		player.plat_vel = Vector3(0, 0, 0)
	player = null
