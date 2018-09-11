extends "res://Stages/Depression/Enemies/TriggerBase.gd"

func reached_target(target):
	set_physics_process(false)
	while(distance_to_target() < MINDISTANCE):
		$ContactTimer.start()
		yield($ContactTimer, "timeout")
	set_physics_process(true)
