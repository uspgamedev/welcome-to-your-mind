extends KinematicBody2D

export(float) var left_position
export(float) var right_position

export var horizontal_speed = 100
var direction = -1
var velocity = Vector2()

func _ready():
	velocity.y = 0
	set_fixed_process(true)
	
func _fixed_process(delta):
	var position = get_pos()
	if ((position.x <= left_position and direction == -1) or (position.x >= right_position and direction == 1)):
		switch_direction()
	motion_change(delta)
	
func switch_direction():
	direction = direction * (-1)
	
func motion_change(time_stamp):
	velocity.x = horizontal_speed * direction
	var motion = velocity * time_stamp
	move(motion)