tool
extends Node2D

const SHADOW_WIDHT = 200
const TRIGGER_SPACE = 50

export (int)var width = 200 setget set_width

var FakeTrig_scn = preload("res://Stages/Depression/Enemies/DeathPit/FakeTrigger.tscn")


func _ready():
	update_pit()


func set_width(w):
	width = w
	update_pit()


func update_pit():
	if has_node("Shadow"):
		$Shadow.set_scale(Vector2(float(width)/SHADOW_WIDHT, 1))
		var shape = $Area2D/CollisionShape2D.get_shape()
		shape.set_extents(Vector2(width/2, 10))
		remove_triggers()
		add_triggers(width)


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		body.die()


func remove_triggers():
	for child in $FakeTriggers.get_children():
		if child.get_position_in_parent() != 0:
			child.queue_free()


func add_triggers(size):
	randomize()
	var sz = size
	var offset = 0
	
	while sz > 100:
		offset += TRIGGER_SPACE
		
		instance_FakeTrigger(Vector2(offset, 0))
		instance_FakeTrigger(Vector2(-offset, 0))
		
		sz -= 100


func instance_FakeTrigger(pos):
	var FakeTrig = FakeTrig_scn.instance()
	
	FakeTrig.get_node("AnimationPlayer").set_speed_scale(rand_range(0.4, 1.1))
	FakeTrig.set_position(pos + Vector2(rand_range(0.0, 2.0) * 5, 0))
	FakeTrig.set_z_index(int(rand_range(0.1, 5.9)))
	$FakeTriggers.add_child(FakeTrig)