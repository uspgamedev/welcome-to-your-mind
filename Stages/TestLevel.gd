extends Node

onready var ASP = get_node("AudioStreamPlayer2D")

func _ready():
	ASP.play()

func _on_AudioStreamPlayer2D_finished():
	ASP.play()