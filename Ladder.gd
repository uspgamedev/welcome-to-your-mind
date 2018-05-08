extends StaticBody

func _on_Area_body_entered(body):
	if body.is_in_group('player'):
		body.ladder = self

func _on_Area_body_exited(body):
	if body.is_in_group('player'):
		body.ladder = null
