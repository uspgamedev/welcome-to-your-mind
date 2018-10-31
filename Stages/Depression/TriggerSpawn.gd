extends Node2D

export (float, 5.0)var respawn_time = 1.0

var Trigger_scn = load("res://Stages/Depression/Enemies/Trigger/TriggerGood.tscn")
var Player
var hasTrigger = false

func _ready():
	$Visual.queue_free()
	$RespawnTimer.set_wait_time(respawn_time)
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
		$RespawnTimer.start()
		hasTrigger = true

func _on_RespawnTimer_timeout():
	spawn()
