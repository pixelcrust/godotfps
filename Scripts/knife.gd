extends Node3D

const dmg = 30
const time_rooted = 1
@onready var player = null
@onready var blood_splatter = $MeshInstance3D/blood_splatter
@onready var shapecast: ShapeCast3D = $ShapeCast3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var ads = 0 #0.. false 1..true
@onready var pos_standard = Vector3(-0.40,-0.10,0.40)
@onready var hand_right: Node3D = $hand_right
@onready var hand_left: Node3D = $hand_left
@export var once = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	hand_right.transform.origin = pos_standard
	hand_left.transform.origin = Vector3(-0.40,-0.10,-2)
	shapecast.transform.origin = Vector3(0,.8,-1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(inventory_selector,player_eyes_position,player_shot,victim):
	shapecast.set_exclude_parent_body(true)
	if animation_player.is_playing():
		pass
	else:
		if once == 0:
			shapecast.clear_exceptions()
			once = 1
		if shapecast.is_colliding():
			#print("raycast collision knife with:" + str(shapecast.get_collider(0)) )
			
			for i in shapecast.collision_result:
				if i.collider.is_in_group("group_player") != true:
					if i.collider.is_in_group("has_hp"):
						i.collider.hit(dmg,time_rooted)
						shapecast.add_exception(i.collider)
						if i.collider.is_in_group("has_blood"):
							blood_splatter.on = true
		animation_player.play("shoot")
		#print_debug(shapecast.collision_result.collider)

func _on_timer_timeout():
	pass


func reload(inventory_selector):
	pass

func inspect():
	if animation_player.is_playing():
		pass
	else:
		animation_player.play("inspect")
