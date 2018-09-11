extends Node2D

const RANDVAR = 10

var player = null

func go_to_player():
	var Tim = $FollowTimer
	var Twn = $Tween
	var randx = (randi() % int(RANDVAR/2)) - RANDVAR
	var randy = (randi() % int(RANDVAR/2)) - RANDVAR
	var dist = get_position().distance_to(player.get_position())
	
	if dist > 70:
		Twn.interpolate_property(self, "position", get_position(), player.get_position() + Vector2(randx, randy),
		 						dist/100.0, Twn.TRANS_CUBIC, Twn.EASE_IN_OUT)
		Twn.start()
	else:
		Tim.set_wait_time(0.1)
		Tim.start()
		yield(Tim, "timeout")
		go_to_player()

func _on_Tween_tween_completed(object, key):
	go_to_player()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player") and not player:
		player = body
		go_to_player()
