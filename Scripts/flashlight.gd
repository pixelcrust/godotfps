extends Node3D

@onready var player = null
@onready var animation_player = $AnimationPlayer
@onready var on = 0
@onready var spotlight_range = 0
@onready var audio_stream_player_3d = $AudioStreamPlayer3D
@onready var ads = 0 #0.. false 1..true
@onready var pos_standard = Vector3(-0.70,-0.10,0.40)
@onready var hand_right = $Node3D/hand_right
@onready var once = true

# Called when the node enters the scene tree for the first time.
func _ready():
	hand_right.transform.origin = pos_standard
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if once == true:
		visible = true
		once = false

func shoot(_inventory_selector,_player_eyes_position):
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

func inspect():
	if animation_player.is_playing():
		pass
	else:
		animation_player.play("inspect")
		
func reload(_inventory_selector):
	if animation_player.is_playing():
		pass
	else:
		animation_player.play("reload")
		
