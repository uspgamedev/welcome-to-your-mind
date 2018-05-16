extends Camera

const YOFFSET = 3
const ZOFFSET = 20
const SMOOTHSPD = 0.3

onready var player = get_parent()
onready var init_y = player.translation.y
var new_y


func _ready():
	set_physics_process(false)


func _process(delta):
	var current_y = init_y - player.translation.y + YOFFSET
	set_translation(Vector3(0, current_y, ZOFFSET))


func _physics_process(delta):
	if init_y >= new_y - SMOOTHSPD and init_y <= new_y + SMOOTHSPD:
		set_physics_process(false)
	else:
		if init_y > new_y:
			init_y -= SMOOTHSPD
		else:
			init_y += SMOOTHSPD


func update_y():
	new_y = player.translation.y
	set_physics_process(true)
