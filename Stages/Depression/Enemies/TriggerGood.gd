extends Node2D

const FLOAT_DISTANCE = 10
const FLOAT_TIME = 2

onready var current_pos = get_position()
var floating_direction = -1 # 1 or -1

func _ready():
	start_floating()

func start_floating():
	var Twn = $Tween
	Twn.interpolate_property(self, "position", current_pos, current_pos + Vector2(0, FLOAT_DISTANCE * floating_direction),
	 						FLOAT_TIME, Twn.TRANS_QUAD, Twn.EASE_IN_OUT)
	Twn.start()
	

func _on_Tween_tween_completed(object, key):
	floating_direction *= -1
	current_pos = get_position()
	start_floating()
