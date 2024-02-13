extends Node3D

const dmg = 30
const time_rooted = 1
@onready var player = null
@onready var shapecast = $MeshInstance3D/ShapeCast3D
@onready var animation_player = $AnimationPlayer

@onready var ads = 0 #0.. false 1..true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(inventory_selector,target_on_raycast):
	if animation_player.is_playing():
		pass
		
	else:		
		await get_tree().create_timer(0.5).timeout
		if shapecast.is_colliding():
			print("raycast collision knife with:" + str(shapecast.get_collider(0)) )
			if(shapecast.get_collider(0).is_in_group("has_hp")):
				shapecast.get_collider(0).hit(dmg,time_rooted)
				#raycast.enabled = false
		animation_player.play("shoot")
		#raycast.enabled = true
		print_debug(shapecast.get_collider(0))
		
func _on_timer_timeout():
	pass


func reload(inventory_selector):
	pass
