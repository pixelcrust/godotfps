extends Node3D

@onready var animationplayer = $AnimationPlayer
@onready var raycast = $MeshInstance3D/RayCast3D
@onready var trap_set = 1
@onready var dmg = 50

@onready var interactiontime_open = 5
@onready var interactiontime_close = 1
@onready var interactiontime = interactiontime_close
@onready var interacted = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if trap_set == 1:
		interactiontime = interactiontime_close
		if interacted == 1:
			animationplayer.play("close")
			trap_set = 0
			interacted = 0
		if raycast.is_colliding():
			if(raycast.get_collider().is_in_group("has_hp")):
				raycast.get_collider().hit(dmg)
			trap_set = 0
			animationplayer.play("close")
	else:
		interactiontime = interactiontime_open
		if interacted == 1:
			animationplayer.play("RESET")
			trap_set = 1
			interacted = 0
