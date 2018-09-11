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

func _process(delta):
    if following == true:
        target = Player.get_position()
        velocity = (target - self.position).normalized() * speed
        move_and_slide(velocity)


func _on_Area2D_body_entered(body):
    if body.is_in_group("Player"):
        following = true

func _on_Area2D_body_exited(body):
    if body.is_in_group("Player"):
        following = false
