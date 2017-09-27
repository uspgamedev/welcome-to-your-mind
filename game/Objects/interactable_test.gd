extends Node2D

onready var interactable = null
onready var collision_shape = null

func _ready():
	set_process_input()

func _input(event):
	if(event.type == InputEvent.Action && event.is_action("ui_interact"))