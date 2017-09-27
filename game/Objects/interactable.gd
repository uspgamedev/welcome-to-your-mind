extends Node2D

#onready var interactable = null
onready var interact_area = get_node('InteractableArea')
onready var sprite = get_node('Sprite')
onready var cooldown = 5

func _ready():
	set_process_input(true)

func _input(event):
	if(event.type == InputEvent.KEY && event.is_action_released("ui_interact")):
		for i in interact_area.get_overlapping_areas():
			if i.is_in_group('player_area'):
				#interactable.interact()
				interact()
				break

func interact():
	var rotation = int(sprite.get_rotd())
	sprite.set_global_rotd((rotation+180)%360)
	#sprite.set_flip_v(true)