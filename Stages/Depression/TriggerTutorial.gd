extends "res://Stages/Depression/Enemies/Trigger/TriggerBase.gd"


func ready():
	set_process_input(false)

func reached_target(target):
	if target.is_in_group("Player"):
		set_physics_process(false)
		get_tree().paused = true
		$TutorialInterface.start(target.get_global_position())

func end_tutorial(): # probably make it rage and transform into a BadTrigger, so player can actually put it's knowledge for the test
	get_tree().paused = false
	die()