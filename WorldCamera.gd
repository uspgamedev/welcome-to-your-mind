extends Camera

onready var player = get_node('../Player')
var initial_camera_transform

func _ready():
    initial_camera_transform = self.get_camera_transform()
    self.translate(player.translation)
    set_process(true)

func _process(delta):
    print(player.translation)
