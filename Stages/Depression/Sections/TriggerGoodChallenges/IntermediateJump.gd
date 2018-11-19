extends Node2D


func _on_CameraPart2Return_enter(body):
	if body.is_in_group("Player"):
		$CameraPartReturn/Area2D/CollisionShape2D.set_disabled(true)
		$CameraPart/Area2D/CollisionShape2D.set_disabled(false)


func _on_CameraPart2_enter(body):
	if body.is_in_group("Player"):
		$CameraPartReturn/Area2D/CollisionShape2D.set_disabled(false)
		$CameraPart/Area2D/CollisionShape2D.set_disabled(true)
