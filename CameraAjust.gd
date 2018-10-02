extends Node2D

# A CollisionShape2D for Area2D must be added to each instance of this node after it is added to a scene.
# Camera values will be updated and transitioned when Player, with a child Camera2D node, enters said Area2D.

export (int)var left_limit = -10000
export (int) var right_limit = 10000
export (int)var top_limit = -10000
export (int) var bottom_limit = 10000
export (float, 0.3, 2)var zoom = 1.0
export (float, 0.1)var adjust_time = 0.5


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		adjust_camera(body.get_node("Camera2D"))

func adjust_camera(Cam):
	$Tween.interpolate_property(Cam, "limit_left", Cam.limit_left, left_limit, adjust_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(Cam, "limit_right", Cam.limit_right, right_limit, adjust_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(Cam, "limit_top", Cam.limit_top, top_limit, adjust_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(Cam, "limit_bottom", Cam.limit_bottom, bottom_limit, adjust_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(Cam, "zoom", Cam.zoom,  Vector2(zoom, zoom), adjust_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()