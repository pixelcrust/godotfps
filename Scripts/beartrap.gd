extends Node3D

@onready var animationplayer = $AnimationPlayer
@onready var raycast = $MeshInstance3D/RayCast3D
@onready var is_active = true
@onready var dmg = 50

@onready var interactiontime_open = 5
@onready var interactiontime_close = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_active and raycast.is_colliding():
		if(raycast.get_collider().is_in_group("has_hp")):
			raycast.get_collider().hit(dmg)
		play_animation()

func get_interaction_time():
	if is_active:
		return interactiontime_close
	return interactiontime_open
	
func play_animation():
	if is_active:
		animationplayer.play("close")
		is_active = false
	else:
		animationplayer.play("RESET")
		is_active = true