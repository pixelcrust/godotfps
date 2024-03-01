extends Node3D

@onready var player = null
@onready var animation_player = $AnimationPlayer
@onready var on = 0
@onready var spotlight_range = 0
@onready var audio_stream_player_3d = $AudioStreamPlayer3D
@onready var ads = 0 #0.. false 1..true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(inventory_selector,_target_on_raycast):
	if animation_player.is_playing():
		pass
	else:
		animation_player.play("shoot")
		audio_stream_player_3d.play(0.0)
		if on == 0:
			player.node_flashlight.spot_range = 0
			on = 1
		else:
			player.node_flashlight.spot_range = spotlight_range
			on = 0


func reload(inventory_selector):
	pass
