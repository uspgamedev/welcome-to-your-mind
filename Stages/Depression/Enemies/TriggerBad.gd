extends KinematicBody2D

export (int) var speed = 100

onready var Player = get_parent().get_node("Player")

func check_distance():
	if get_position().distance_to(Player.get_position()) < 300:
		return true
	else:
		return false

func _physics_process(delta):
	var following = check_distance()

	if following == true:
		var target = Player.get_position()
		var velocity = (target - self.position).normalized() * speed * delta
		move_and_slide(velocity)
