extends 'res://body.gd'

onready var detected = false
onready var player = null
onready var rout_timer = get_node('RoutineTimer')
onready var grab_timer = get_node('GrabTimer')
onready var direction = -1
onready var grabbing = false
onready var release = 0

const SPEED = 5

func _ready():
	set_fixed_process(true)
	rout_timer.start()
	rout_timer.connect('timeout', self, 'routine_turn')

func _fixed_process(delta):
	check_detection()

func check_detection():
	if (grabbing):
		grab()
	elif (!detected):
		passive()
	else:
		aggressive()

func routine_turn():
	direction *= -1
	change_dir(direction)

func run():
	speed.z = direction * SPEED

func stop():
	speed.z = 0

func grab():
	if (rout_timer.is_active()):
		rout_timer.set_active(false)
		player.encostinhos += 1
		player.slow_down()
	var player_rotation
	if (player.get_rotation() == Vector3(0, 0, 0)):
		player_rotation = -3
	else:
		player_rotation = 3
	self.set_layer_mask(2)
	self.set_translation(player.get_translation() - Vector3(0, 0, player_rotation))

func passive():
	self.set_layer_mask(1)
	rout_timer.set_active(true)
	rout_timer.start()
	SPEED = 2
	run()

func aggressive():
	rout_timer.stop()
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

func interact():
	release += 1
	if (release >= 6):
		release = 0
		player.speed_up()
		grabbing = false
		detected = false
		grab_timer.connect('timeout', self, 'check_player_area')

func check_player_area():
	if (get_node('EnemyVision').overlaps_area(player.get_node('PlayerArea'))):
		detected = true
	grab_timer.disconnect('timeout', self, 'check_player_area')

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
