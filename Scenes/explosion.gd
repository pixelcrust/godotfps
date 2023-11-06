extends Node3D

@onready var idle = true
@onready var gpu_particles_3d_3 = $GPUParticles3D3
@onready var gpu_particles_3d_2 = $GPUParticles3D2
@onready var gpu_particles_3d = $GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if idle != true:
		gpu_particles_3d_3.set_emitting(true)
		gpu_particles_3d_2.set_emitting(true)
		gpu_particles_3d.set_emitting(true)



func _signal_explosion():
	print("boom")
	idle = false # Replace with function body.
