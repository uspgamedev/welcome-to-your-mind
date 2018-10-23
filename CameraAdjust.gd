extends Node2D

# A CollisionShape2D for Area2D must be added to each instance of this node after it is added to a scene.
# Camera values will be updated and transitioned when Player, with a child Camera2D node, enters said Area2D.

export (int) var left_limit = -10000
export (int) var right_limit = 10000
export (int) var top_limit = -10000
export (int) var bottom_limit = 10000
export (float, 0.3, 2) var zoom = 1.0
export (Vector2) var init_pos = Vector2(0, 0)
export (float, 0.1, 3.0) var adjust_time = 0.5


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		adjust_Camera(body.get_node("Camera2D"))

func adjust_Camera(Cam):
	var p_pos = get_parent().get_position()
	var old_pos = Cam.get_global_position()
	var Player = Cam.get_parent()
	
	take_Camera_from_Player(Player, Cam)
	
	$Tween.interpolate_property(Cam, "global_position", old_pos, init_pos + p_pos, adjust_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(Cam, "zoom", Cam.zoom,  Vector2(zoom, zoom), adjust_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	expand_limits(Cam, p_pos)
	yield($Tween, "tween_completed")
	
	give_Camera_to_Player(Player, Cam)
	
	Cam.limit_left = left_limit + p_pos.x
	Cam.limit_right = right_limit + p_pos.x
	Cam.limit_top = top_limit + p_pos.y
	Cam.limit_bottom = bottom_limit + p_pos.y

func take_Camera_from_Player(Player, Cam):
	Player.remove_child(Cam)
	get_parent().add_child(Cam)

func give_Camera_to_Player(Player, Cam):
	get_parent().remove_child(Cam)
	Player.add_child(Cam)

func expand_limits(Cam, p_pos):
	if Cam.limit_left > left_limit + p_pos.x:
		Cam.limit_left = left_limit + p_pos.x
	if Cam.limit_right < right_limit + p_pos.x:
		Cam.limit_right = right_limit + p_pos.x
	if Cam.limit_top > top_limit + p_pos.y:
		Cam.limit_top = top_limit + p_pos.y
	if Cam.limit_bottom < bottom_limit + p_pos.y:
		Cam.limit_bottom = bottom_limit + p_pos.y 

func extrapolate_limits(Cam):
	Cam.limit_left =  -1000000
	Cam.limit_right =  1000000
	Cam.limit_top =   -1000000
	Cam.limit_bottom = 1000000