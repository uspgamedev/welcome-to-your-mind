extends 'res://body.gd'

onready var detected = false
onready var player = null

const SPEED = 5

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	check_detection()

func check_detection():
	if (!detected):
		passive()
	else:
		aggressive()

func run():
	speed.z = dir * SPEED

func stop():
	speed.z = 0

func passive():
	speed.z = 0

func aggressive():
	var vector = player.get_translation() - self.get_translation()
	if (vector.z < -3):
		change_dir(-1)
		run()
	elif (vector.z > 3):
		change_dir(1)
		run()
	else:
		stop()

func change_dir(direction):
	dir = direction

func _on_EnemyVision_area_enter(area):
	if (area.is_in_group('player_area')):
		if (player == null):
			player = area.get_parent()
		detected = true

func _on_EnemyVision_area_exit(area):
	if (area.is_in_group('player_area')):
		detected = false
