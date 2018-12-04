extends Node

var respawn_point = Vector2(195, -1420)
var respawn_camera = [-80, -1900, 7450, 600, 1] # left, top, right, bottom, zoom


func update_respawn_camera(Player):
	var Cam = Player.get_node("Camera2D")
	respawn_camera = [Cam.limit_left, Cam.limit_top, Cam.limit_right, Cam.limit_bottom, Cam.zoom.x]


func set_camera_limits(Player):
	var Cam = Player.get_node("Camera2D")
	Cam.limit_left = respawn_camera[0]
	Cam.limit_top = respawn_camera[1]
	Cam.limit_right = respawn_camera[2]
	Cam.limit_bottom = respawn_camera[3]
	Cam.zoom = Vector2(respawn_camera[4], respawn_camera[4])


func _on_Checkpoint1_body_entered(body):
	if not body.is_in_group("Player"):
		return
	
	$Checkpoints/Checkpoint1.queue_free()
	$IntroTriggerBad.queue_free()
	respawn_point = Vector2(3730, 237)
	update_respawn_camera(body)


func _on_Checkpoint2_body_entered(body):
	if not body.is_in_group("Player"):
		return
	
	$Checkpoints/Checkpoint2.queue_free()
	respawn_point = Vector2(6890, 267)
	update_respawn_camera(body)


func _on_Player_died():
	$Player.set_global_position(respawn_point)
	set_camera_limits($Player)
	$Player.set_physics_process(true)
	$Player.set_process(true)
