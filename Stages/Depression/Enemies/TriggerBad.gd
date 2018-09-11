extends "res://Stages/Depression/Enemies/TriggerBase.gd"

func reached_target(target):
	set_physics_process(false)
	if target.is_in_group("Player"):
		target.add_trigger(self)

func shaked_off():
	var parentparent = get_parent().get_parent()
	var pos = get_global_position()
	
	get_parent().remove_child(self)
	set_position(pos)
	parentparent.add_child(self)
	$ShakenOffTimer.start()
	yield($ShakenOffTimer, "timeout")
	set_physics_process(true)