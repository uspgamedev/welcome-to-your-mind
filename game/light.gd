extends OmniLight

var gb
onready var r = 1
onready var player = get_parent()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	gb = 1 + max(min(player.get_translation().z, 0), -100) / 100
	if (player.get_translation().z < -100):
		r = 3
	elif (r < 3):
		r = max(min(1, 2 * gb), 0.7)
	self.set_color(0, Color(r, gb, gb))
