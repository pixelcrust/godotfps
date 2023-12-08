extends Node3D

const dmg = 700
const time_rooted = 1
@onready var player = null
@onready var raycast = $MeshInstance3D/RayCast3D
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
		
		if raycast.is_colliding():
			print("raycast collision knife with:" + str(raycast.get_collider()) )
			if(raycast.get_collider().is_in_group("has_hp")):
				raycast.get_collider().hit(dmg,time_rooted)
				#raycast.enabled = false
		animation_player.play("shoot")
		#raycast.enabled = true
		print_debug(raycast.get_collider())

func reload(inventory_selector):
	pass
