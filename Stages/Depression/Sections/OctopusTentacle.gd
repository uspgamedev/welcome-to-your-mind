extends Node2D


#func _ready():
#	$Octopus.activate($Player)


func _on_Area2D_body_entered(body):
	$Octopus.activate($Player)
