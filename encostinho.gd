extends KinematicBody

const MAX_SLOPE_ANGLE = 40

var player = null
var vel = Vector3(5, 0, 0)
var pos


func _on_AreaInteraction_body_entered(body):
	if body.is_in_group('player'):
		body.encostinho_colision(self)
		player = body
		pos = Vector3(rand_range(0.5, 1.0) * pos_or_neg(), rand_range(0.5, 1.0) * pos_or_neg(), rand_range(.5, 1.0))

func _on_AreaInteraction_body_exited(body):
	if body.is_in_group('player'):
		body.encostinho_left(self)
		player = null

func pos_or_neg():
	var r = randi() % 2
	if r == 0:
		return -1
	return 1

func _physics_process(delta):
	if player:
		self.set_translation(player.get_translation() + pos)
	move_and_slide(vel)

func _on_Timer_timeout():
	vel.x *= -1

func _on_AreaVision_body_entered(body):
	pass
