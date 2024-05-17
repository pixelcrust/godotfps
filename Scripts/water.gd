extends Node3D

@onready var player = 0
@onready var water_splash = $water_splash
@onready var audio_stream_player_3d = $AudioStreamPlayer3D
@onready var sound_splash = preload("res://Sounds/object dropped in water 6.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	water_splash.global_position = body.global_position
	water_splash.emitter.restart()
	water_splash.emitter.emitting = true
	audio_stream_player_3d.stream = sound_splash
	audio_stream_player_3d.play(0.0)
	if body == player:
		player.in_water = true 
	#print(player.bone_head)
	
	


func _on_area_3d_body_exited(body):
	if body == player:
		player.in_water = false
