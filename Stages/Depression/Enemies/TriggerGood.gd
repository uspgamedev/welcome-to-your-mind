extends "res://Stages/Depression/Enemies/TriggerBase.gd"

signal trigger_die

func reached_target(target):
	set_physics_process(false)
	if(target.is_in_group("Player")):
		target.can_jump = true	
		emit_signal("trigger_die")
		die()
	else:
		set_physics_process(true)
