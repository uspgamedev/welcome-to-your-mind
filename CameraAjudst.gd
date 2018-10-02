extends Node2D

export (int)var left_limit = -10000
export (int) var right_limit = 10000
export (int)var top_limit = -10000
export (int) var bottom_limit = 10000
export (float, 0.3, 2)var zoom = 1.0


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		adjust_camera(body.get_node("Camera2D"))

func adjust_camera(Cam):
	Cam.limit_left = left_limit
	Cam.limit_right = right_limit
	Cam.limit_top = top_limit
	Cam.limit_bottom = bottom_limit
	Cam.zoom = Vector2(zoom, zoom)