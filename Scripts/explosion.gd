extends Node3D

@onready var idle = true
@onready var sparks = $sparks
@onready var flash = $flash
@onready var smoke = $smoke
@onready var damage = 500
@onready var collision_explosion = $ShapeCast3D
@onready var time_rooted = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if idle != true:
		sparks.set_emitting(true)
		flash.set_emitting(true)
		smoke.set_emitting(true)
		var number_victims = collision_explosion.get_collision_count()
		print(number_victims)
		for n in number_victims:
			var victim = collision_explosion.get_collider(n)
			victim.hit(damage,time_rooted)
			#victim.apply_impulse(-transform.basis.z *4)
			print(n)
		idle = true



func _signal_explosion():
	idle = false # Replace with function body.

