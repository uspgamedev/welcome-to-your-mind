extends StaticBody

var player = null
onready var init_trans = self.get_translation()

func _on_Area_body_entered(body):
	if body.is_in_group('player'):
		player = body
		player.set_physics_process(false)
		player.set_translation(self.get_translation())
		$Timer.start()
		print('start')

func _physics_process(delta):
	#self.set_translation(init_trans + Vector3(0.05 - randf()/10, 0.05 - randf()/10, 0.05 - randf()/10))
	pass

func _on_Timer_timeout():
	if player != null:
		player.set_physics_process(true)
		player.MaoTimer.stop()
