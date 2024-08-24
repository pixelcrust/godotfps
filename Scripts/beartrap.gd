extends Node3D

@onready var animationplayer = $AnimationPlayer
@onready var raycast = $MeshInstance3D/RayCast3D
@onready var is_active = true
@onready var dmg = 50

@onready var outline_mesh = $MeshInstance3D/MeshInstance3D

@onready var interactiontime_open = 3
@onready var interactiontime_close = .7
const time_rooted = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_active and raycast.is_colliding():
		if(raycast.get_collider().is_in_group("has_hp")):
			raycast.get_collider().hit(dmg,time_rooted)
		use()

func get_interaction_time():
	if is_active:
		return interactiontime_close
	return interactiontime_open
	
func use():
	if is_active:
		animationplayer.play("close")
		is_active = false
	else:
		animationplayer.play("RESET")
		is_active = true
		
