extends KinematicBody

func _on_Area_body_entered(body):
    if body.is_in_group('player'):
        body.encostinhos.append(self)
        body.encostinho_colision()

