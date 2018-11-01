extends Node2D


func _on_ChallengeArea2D_body_entered(body):
	if body.is_in_group("Player"):
		$ChallengeCamera/Area2D/CollisionShape2D.set_disabled(true)
		$EasyCamera/Area2D/CollisionShape2D.set_disabled(false)

func _on_EasyArea2D_body_entered(body):
	if body.is_in_group("Player"):
		$ChallengeCamera/Area2D/CollisionShape2D.set_disabled(false)
		$EasyCamera/Area2D/CollisionShape2D.set_disabled(true)
