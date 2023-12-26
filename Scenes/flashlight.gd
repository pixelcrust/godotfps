extends Node3D

@onready var player = null
@onready var animation_player = $AnimationPlayer
@onready var on = 0
@onready var range = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(inventory_selector):
	if on == 0:
		player.node_flashlight.spot_range = 0
		on = 1
	else:
		player.node_flashlight.spot_range = range
		on = 0


func reload(inventory_selector):
	pass
