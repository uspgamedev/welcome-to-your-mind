extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var ASP = get_node("AudioStreamPlayer2D")

func _ready():
	ASP.play()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_AudioStreamPlayer2D_finished():
	ASP.play()