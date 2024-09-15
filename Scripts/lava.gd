extends Node3D

@onready var player = 0
@onready var time_rooted = 0
@onready var dmg = 2
@onready var collision_shape = $Area3D/CollisionShape3D
#@onready var area_3d_2 = $Area3D2
@onready var player_burning = false
@onready var lava_splash = $lava_splash

@onready var audio_stream_player_3d = $AudioStreamPlayer3D
@onready var sound_splash = preload("res://Sounds/object dropped in water 6.wav")
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_burning == true:
		player.bone_body.hit(dmg,time_rooted)


func _on_area_3d_body_entered(body):
	
	audio_stream_player_3d.stream = sound_splash
	audio_stream_player_3d.play(0.0)
	lava_splash.global_position = body.global_position
	lava_splash.emitter.restart()
	lava_splash.emitter.emitting = true
	if body == player:
		player.in_water = true
		player_burning = true
		
	#print(player.bone_head)
	print(body)
	


func _on_area_3d_body_exited(body):
	if body == player:
		player.in_water = false
		player_burning = false
