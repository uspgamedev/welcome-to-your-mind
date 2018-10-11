extends Node2D

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		$Octopus.activate(body)
		lower_left_door()

func lower_left_door():
	var LD = $LeftDoor
	var Twn = $LeftDoor/Tween
	
	Twn.interpolate_property(LD, "position", LD.get_position(),  LD.get_position() + Vector2(0, 170), 1.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	Twn.start()