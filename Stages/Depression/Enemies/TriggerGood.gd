extends "res://Stages/Depression/Enemies/TriggerBase.gd"

signal trigger_absorbed(Absorber)

func reached_target(target):
	set_physics_process(false)
	
	if target.is_in_group("Player"):
		target.can_jump = true
		emit_signal("trigger_absorbed", target)
		die()
	else:
		set_physics_process(true)
