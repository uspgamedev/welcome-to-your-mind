extends Node2D

onready var hitted = false

func die():
	print("UE")
	queue_free()

func _on_Area2D_area_entered(area):
	if area.get_parent().is_in_group("TriggerBad") and not hitted:
		hitted = true
		self.die()