extends Node2D

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		$Octopus.activate(body)
		lower_left_door()

func lower_left_door():
	var LD = $Wall/LeftDoor
	var Twn = $Wall/LeftDoor/Tween
	
	Twn.interpolate_property(LD, "position", LD.get_position(),  LD.get_position() + Vector2(0, 170), 1.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	Twn.start()

func lower_right_door():
	var RD = $Wall/RightDoor
	var Twn = $Wall/RightDoor/Tween
	
	Twn.interpolate_property(RD, "position", RD.get_position(),  RD.get_position() + Vector2(0, 170), 1.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	Twn.start()

func _on_ExitArea_body_entered(body):
	if body.is_in_group("Player"):
		lower_right_door()
