extends Node2D

# A CollisionShape2D for Area2D must be added to each instance of this node after it is added to a scene.
# Camera values will be updated and transitioned when Player, with a child Camera2D node, enters said Area2D.

export (int) var left_limit = -10000
export (float, 3.0) var left_time = 0.5
export (int) var right_limit = 10000
export (float, 3.0) var right_time = 0.5
export (int) var top_limit = -10000
export (float, 3.0) var top_time = 0.5
export (int) var bottom_limit = 10000
export (float, 3.0) var bottom_time = 0.5
export (float, 0.3, 2) var zoom = 1.0
export (float, 3.0) var zoom_time = 0.5


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		adjust_Camera(body.get_node("Camera2D"))

func adjust_Camera(Cam):
	var p_pos = get_parent().get_position()
	var Player = Cam.get_parent()
	
	take_Camera_from_Player(Player, Cam)
	
	$Tween.interpolate_property(Cam, "limit_left", Cam.limit_left,  left_limit + p_pos.x, left_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(Cam, "limit_right", Cam.limit_right,  right_limit + p_pos.x, right_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(Cam, "limit_top", Cam.limit_top,  top_limit + p_pos.y, top_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(Cam, "limit_bottom", Cam.limit_bottom,  bottom_limit + p_pos.y, bottom_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(Cam, "zoom", Cam.zoom,  Vector2(zoom, zoom), zoom_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	
	give_Camera_to_Player(Player, Cam)

func take_Camera_from_Player(Player, Cam):
	Player.remove_child(Cam)
	get_parent().add_child(Cam)

func give_Camera_to_Player(Player, Cam):
	get_parent().remove_child(Cam)
	Player.add_child(Cam)