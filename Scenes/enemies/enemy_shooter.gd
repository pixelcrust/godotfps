extends CharacterBody3D

@export var PlayerPath : NodePath
@export var color : Color
@export var aggroRange := 5.0
@export var fireSpeed := 0.2
@export var attackPower := 1

var health = 20
var material
var player = null
var bullet = preload("res://Scenes/bullets/bullet.tscn")

@onready var gun: Marker3D = $gun
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var sight: RayCast3D = $sight
@onready var engagedTimer: Timer = $engage

3:19
func _on_engage_timeout() -> void:
	pass # Replace with function body.
