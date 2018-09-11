extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (int) var speed = 1

var following = false
var target = Vector2()
var velocity = Vector2()
onready var Player = get_parent().get_node("Player")

func _ready():
    set_process(true)
    set_physics_process(true)

func check_distance():
    if get_position().distance_to(Player.get_position()) < 300:
        following = true
    else:
        following = false

func _process(delta):
    check_distance()
    
    if following == true:
        target = Player.get_position()
        velocity = (target - self.position).normalized() * speed
        move_and_slide(velocity)

