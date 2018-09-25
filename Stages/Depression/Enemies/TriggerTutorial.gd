extends "res://Stages/Depression/Enemies/TriggerBase.gd"

const SHAKENUM = 7 # Times needed to shake before freeing itself from Triggers

var last_shake = 0 # 0 is left, 1 is right. Used to force alternating directions in shake
var shake_counter = 0

onready var tutorialanimation = get_node("InterfaceTutorial")

func ready():
	set_process_input(false)

func reached_target(target):
	set_physics_process(false)
	set_process_input(true)
	tutorialanimation.visible = true
	tutorialanimation.get_node("Sprite").get_node("AnimationPlayer").play("Cor")
	#self.pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	
func _input(event):
	if Input.is_action_pressed('ui_right'):
		print("DIREITA")
		shake(1)
	elif Input.is_action_pressed('ui_left'):
		print("ESQUERDA")
		shake(0)
		
func shake(shake_direction):
	print(shake_counter)
	if shake_direction == last_shake:
		return
	last_shake = shake_direction
	$ShakeTimer.start()
	shake_counter += 1
	if shake_counter >= SHAKENUM:
		print("SOLTOU")
		set_process_input(false)
		tutorialanimation.visible = false
		self.die()
		get_tree().paused = false

func _on_ShakeTimer_timeout():
	shake_counter = 0