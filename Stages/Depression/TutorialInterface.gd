extends CanvasLayer

const SHAKENUM = 7 # Times needed to shake before freeing itself from Triggers

export (bool)var DEBUG = 0

onready var AnimLeft = $Center/ButtonLeft/AnimationPlayer
onready var AnimRight = $Center/ButtonRight/AnimationPlayer

var last_shake = 0 # 0 is left, 1 is right. Used to force alternating directions in shake
var shake_counter = 0
var last = 0 # 0 = left; 1 = right

func start(pos):
	$Center.set_global_position(pos)
	$Center.visible = true
	$Interval.start()

func _on_Interval_timeout():
	last = (last + 1) % 2
	if last == 0:
		AnimLeft.play("press")
		AnimRight.play("release")
	else:
		AnimRight.play("press")
		AnimLeft.play("release")

func fade_out():
	var Twn = $Tween
	$ShakeTimer.queue_free()
	$Interval.queue_free()
	Twn.interpolate_property($Center, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	Twn.start()


func _input(event):
	$Interval.stop()
	if Input.is_action_just_pressed('ui_left'):
		if DEBUG:
			print("Left pressed on Tutorial")
		shake(0)
		AnimLeft.play("press")
		AnimRight.play("release")
	elif Input.is_action_just_pressed('ui_right'):
		if DEBUG:
			print("Right pressed on Tutorial")
		shake(1)
		AnimRight.play("press")
		AnimLeft.play("release")

func shake(shake_direction):
	if shake_direction == last_shake:
		return
	last_shake = shake_direction
	$ShakeTimer.start()
	shake_counter += 1
	if DEBUG:
		print("Tutorial counter: ", shake_counter)
	if shake_counter >= SHAKENUM:
		if DEBUG:
			print("Tutorial Succeded")
		set_process_input(false)
		fade_out()
		get_parent().die()

func _on_ShakeTimer_timeout():
	if DEBUG and shake_counter != 0:
		print("Reseted tutorial counter")
	shake_counter = 0
	$Interval.start()
