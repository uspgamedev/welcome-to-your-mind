extends Node

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	input.connect('press_quit', self, 'quit')
	input.connect('press_respawn', self, 'respawn')
	set_fixed_process(true)

func respawn():
	get_tree().change_scene('res://TestScene.tscn')

func quit():
	get_tree().quit()
