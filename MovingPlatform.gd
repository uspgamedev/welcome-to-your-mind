extends KinematicBody

const MOVE_SPD = 0.05

onready var initial_trans = self.get_translation()
var distance = 10
var i = 0

func _physics_process(delta):
	self.set_translation(initial_trans + Vector3((sin(i) * distance), 0, 0))
	i += MOVE_SPD
	if (i > 2 * PI):
		i = 0


func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		set_process(true)


func _on_Area_body_exited(body):
	pass # replace with function body
