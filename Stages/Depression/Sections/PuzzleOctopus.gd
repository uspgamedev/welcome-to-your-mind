extends Node2D

const DOOR_SPD = 0.8

func lower_left_door():
	var LD = $Wall/LeftDoor
	var Twn = $Wall/LeftDoor/Tween
	
	Twn.interpolate_property(LD, "position", LD.get_position(),  LD.get_position() + Vector2(0, 170), DOOR_SPD, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	Twn.start()

func lower_right_door():
	var RD = $Wall/RightDoor
	var Twn = $Wall/RightDoor/Tween
	
	Twn.interpolate_property(RD, "position", RD.get_position(),  RD.get_position() + Vector2(0, 170), DOOR_SPD, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	Twn.start()

func _on_EnterArea_body_exited(body):
	if body.is_in_group("Player"):
		if body.get_global_position().x > $EnterArea.get_global_position().x:
			lower_left_door()
			$Octopus.activate(body)
		
func _on_ExitArea_body_exited(body):
	if body.is_in_group("Player"):
		if body.get_global_position().x > $ExitArea.get_global_position().x:
			lower_right_door()
			$Octopus.deactivate()
