extends Node2D

var hasTrigger = false

func _ready():
	spawn()
	hasTrigger = true

func spawn():
	var trigger = load("res://Stages/Depression/Enemies/TriggerGood.tscn")
	var trigger_instance = trigger.instance()
	trigger_instance.connect("trigger_die", self, "trigger_died")
	add_child(trigger_instance)
	
func trigger_died():
	hasTrigger = false

func _on_Player_jumped():
	if hasTrigger == false:
		$Timer.start()
		hasTrigger = true

func _on_Timer_timeout():
	spawn()
