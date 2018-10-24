extends Node2D

var Trigger_scn = load("res://Stages/Depression/Enemies/TriggerGood.tscn")
var Player
var hasTrigger = false

func _ready():
	spawn()

func spawn():
	instance_Trigger()
	hasTrigger = true

func instance_Trigger():
	var Trig = Trigger_scn.instance()
	Trig.connect("trigger_absorbed", self, "trigger_gone")
	add_child(Trig)

func trigger_gone(Absorber):
	Player = Absorber
	if not Player.is_connected("jumped", self, "Player_jumped"):
		Player.connect("jumped", self, "Player_jumped")
	hasTrigger = false

func Player_jumped():
	if hasTrigger == false:
		$Timer.start()
		hasTrigger = true

func _on_Timer_timeout():
	spawn()
