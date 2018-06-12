extends StaticBody

var player = null

func _on_Area_body_entered(body):
	if body.is_in_group('player'):
		player = body
		player.set_physics_process(false)
		player.set_translation(self.get_translation() - Vector3(0, 0, 1))
		$Timer.start()

func _on_Timer_timeout():
	if player != null:
		player.set_physics_process(true)
		player.get_node("MaoTimer").stop()
		self.queue_free()
