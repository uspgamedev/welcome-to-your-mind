extends Node2D

export (int)var SPEED = 300
export (Vector2)var DIRECTION = Vector2(0, 1)


func _physics_process(delta):
	var velocity = DIRECTION.normalized() * SPEED * delta
	set_position(get_position() + velocity)

func _on_FloorDetectionArea_body_entered(body):
	if body.is_in_group("floor"):
		queue_free()
