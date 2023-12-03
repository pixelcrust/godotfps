extends Node3D

const SPEED = 40.0
const ACCURACY = 0.35
const dmg = 10
const time_rooted = .1

@onready var mesh = $MeshInstance3D
@onready var raycast = $RayCast3D
@onready var particles = $GPUParticles3D
@onready var abweichung_x = randf_range(-ACCURACY,ACCURACY)
@onready var abweichung_y = randf_range(-ACCURACY,ACCURACY)
@onready var sound = $AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	sound.play(0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += transform.basis * Vector3(SPEED,0+abweichung_y,0+abweichung_x)*delta
	if raycast.is_colliding():
		print("raycast collision with:" + str(raycast.get_collider()) )
		mesh.visible = false
		particles.emitting = true
		if(raycast.get_collider().is_in_group("has_hp")):
			raycast.get_collider().hit(dmg,time_rooted)
		raycast.enabled = false
		await get_tree().create_timer(1.0).timeout
		queue_free()


func _on_timer_timeout():
	queue_free()
