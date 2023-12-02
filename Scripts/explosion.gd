extends Node3D

@onready var idle = true
@onready var sparks = $sparks
@onready var flash = $flash
@onready var smoke = $smoke
@onready var damage = 50
@onready var collision_explosion = $ShapeCast3D



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
		for n in number_victims:
			var victim = collision_explosion.get_collider(n)
			victim.hit(damage)
		idle = true



func _signal_explosion():
	idle = false # Replace with function body.
