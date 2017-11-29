extends 'res://body.gd'

onready var detected = false
onready var player = null
onready var timer = get_node('Timer')
onready var direction = -1
onready var grabbing = false

const SPEED = 5

func _ready():
	set_fixed_process(true)
	timer.start()
	timer.connect('timeout', self, 'timer_timeout')

func _fixed_process(delta):
	check_detection()

func check_detection():
	if (grabbing):
		grab()
	elif (!detected):
		passive()
	else:
		aggressive()

func timer_timeout():
	direction *= -1
	change_dir(direction)

func run():
	speed.z = direction * SPEED

func stop():
	speed.z = 0

func grab():
	var player_rotation
	if (player.get_rotation() == Vector3(0, 0, 0)):
		player_rotation = -3
	else:
		player_rotation = 3
	self.set_layer_mask(2)
	self.set_translation(player.get_translation() - Vector3(0, 0, player_rotation))

func passive():
	SPEED = 2
	run()

func aggressive():
	SPEED = 5
	var vector = player.get_translation() - self.get_translation()
	if (vector.z < -3):
		change_dir(-1)
		run()
	elif (vector.z > 3):
		change_dir(1)
		run()
	else:
		grabbing = true

func change_dir(new_direction):
	direction = new_direction

func _on_EnemyVision_area_enter(area):
	if (area.is_in_group('player_area')):
		if (player == null):
			player = area.get_parent()
		detected = true

func _on_EnemyVision_area_exit(area):
	if (area.is_in_group('player_area')):
		detected = false
