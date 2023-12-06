extends Node3D

const DMG = 70
@onready var player = null
@onready var ray_cast_3d = $MeshInstance3D/RayCast3D
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(inventory_selector):
	if animation_player.is_playing():
		pass
	else:		
		animation_player.play("shoot")
	pass

func reload(inventory_selector):
	pass
