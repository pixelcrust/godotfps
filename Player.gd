extends CharacterBody3D

var speed
const SPEED_CROUCH = 1.0
const SPEED_WALK = 3.0
const SPEED_RUN = 6.0
const JUMP_VELOCITY = 4.5


const SENSITIVITY = 0.001

#head bob
const BOB_FREQUENCY = 2.0
const BOB_AMPLITUDE = 0.08
var t_bob = 0.0
#fov constants
const FOV_BASE = 75.0
const FOV_SPRINT_SCALE = 1.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var guncamera = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D
@onready var raycast_interaction = $Head/Camera3D/raycast_interaction
@onready var collisionshape = $CollisionShape3D2
@onready var mesh = $MeshInstance3D
@onready var equipped = null
@onready var animation_player = $AnimationPlayer

@onready var display_ammo = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/display_ammo
@onready var display_hp = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/display_hp
@onready var display_interaction = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/display_interaction


@onready var state_move = 0

#0.. walking
#1.. running
#2.. crouching
#3.. in air

@onready var is_rooted = false
@onready var is_interacting = 0

@onready var equipped_id = -1 #what item in hand
#-1.. nothing
#0.. gun
#1.. shotgun

@onready var inventory = []
@onready var inventory_selector = 0

#inventory slots and icons
@onready var display_inventory = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/display_inventory
@onready var inv_slot_1 = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/display_inventory/inv_1
@onready var inv_slot_2 = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/display_inventory/inv_2
@onready var inv_slot_3 = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/display_inventory/inv_3
@onready var icon_pistol = preload("res://Sprites/icons/icon_pistol.png")
@onready var icon_shotgun = preload("res://Sprites/icons/icon_shotgun.png")
@onready var icon_sniper = preload("res://Sprites/icons/icon_sniper.png")
@onready var inventory_marker = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/display_inventory/inventory_marker
@onready var inventory_timer = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/display_inventory/inv_timer

#preload equippment? move somewhere
@onready var asset_gun = preload("res://Scenes/gun.tscn")
@onready var asset_shotgun = preload("res://Scenes/shotgun.tscn")
@onready var asset_sniper = preload("res://Scenes/sniper.tscn")

@onready var hp_start = 150
@onready var hp = hp_start

func _ready():
	#adda gun to inventory
	inventory.append({
	"item_id": 0, #pistol
	"loaded": 7,
	"max_loaded": 7, # See above assignment.
	"spare_ammo": 100
	})
	
	inventory.append({
	"item_id": 2, #sniper
	"loaded": 5,
	"max_loaded": 5, 
	"spare_ammo": 10
	})
	
	inventory.append({
	"item_id": 1, #shotgun
	"loaded": 2,
	"max_loaded": 2, 
	"spare_ammo": 4
	})
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	equip_weapon()
	#var MainEnv = camera.get_environment()
	#guncamera.set_environment(MainEnv)

	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x*SENSITIVITY)
		camera.rotate_x(-event.relative.y*SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x,deg_to_rad(-89),deg_to_rad(90))
		
func _physics_process(delta):

	#restart scene
	if(Input.is_action_just_pressed("restart")):
		get_tree(). reload_current_scene()
		
	#if ded
	if hp <= 0:
		die()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		state_move = 3
	else:
		state_move = 0
	
	#display ammo
	display_ammo.clear()
	display_ammo.insert_text_at_caret(str(inventory[inventory_selector].loaded)+"/"+str(inventory[inventory_selector].spare_ammo))
	
	#display hp
	display_hp.clear()
	display_hp.insert_text_at_caret(str(hp))
	
	# Handle Jump.
	if Input.is_action_just_pressed("key_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#run
	if (Input.is_action_pressed("key_run") && (state_move < 2)):
		set_speed(SPEED_RUN)
		state_move = 1
	elif(Input.is_action_pressed("key_crouch") && (state_move != 2)):
		set_speed(SPEED_CROUCH)
		state_move = 2
	else:
		set_speed(SPEED_WALK)
		state_move = 0
	
	# Start interaction
	if Input.is_action_just_pressed("Interact")  and raycast_interaction.is_colliding():
		if raycast_interaction.get_collider().is_in_group("interactable"):
			display_interaction.visible = true
			var obj_interaction_time = raycast_interaction.get_collider().object.get_interaction_time()
			display_interaction.value = (is_interacting/obj_interaction_time*100)
			print("Starting interaction")
			is_interacting += delta
	
	# Csontinue interaction
	elif is_interacting > 0 and Input.is_action_pressed("Interact") and raycast_interaction.is_colliding():
		if raycast_interaction.get_collider().is_in_group("interactable"):
			var obj_interaction_time = raycast_interaction.get_collider().object.get_interaction_time()
			display_interaction.value = (is_interacting/obj_interaction_time*100)
			print("Continuing interaction: " + str(is_interacting/obj_interaction_time*100))
			is_interacting += delta
			if(is_interacting >= obj_interaction_time):
				# Finish interaction
				display_interaction.set_show_percentage(false)
				raycast_interaction.get_collider().object.play_animation()
				is_interacting = 0
	
	# Stop interaction
	else:
		is_interacting = 0
		display_interaction.visible = false

	
	#swap weapon
	if Input.is_action_just_pressed("key_next_weapon"):
		
		if equipped != null:
			if equipped.animation_player.is_playing():
				pass
			else:
				equipped.animation_player.play("change weapon out") #this does not work
		equipped.queue_free() 
		inventory_selector += 1
		equip_weapon()
		
	#shoot
	if(Input.is_action_just_pressed("key_shoot")):
		if equipped_id != -1:
			equipped.shoot(inventory_selector)
		else:
			pass
	
	#reload
	if(Input.is_action_just_pressed("key_reload")):
		if equipped_id != -1:
			equipped.reload(inventory_selector)
		else:
			pass
	
	#crouch
	match state_move:
		2:
			collisionshape.scale.y = 0.5
			mesh.scale.y = 0.5
		_:
			collisionshape.scale.y = 1
			mesh.scale.y = 1
			pass
	
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("key_left", "key_right", "key_forward", "key_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * get_speed()
			velocity.z = direction.z * get_speed()
		else:
			velocity.x = lerp(velocity.x,direction.x*get_speed(),delta*7.0)
			velocity.z = lerp(velocity.z,direction.z*get_speed(),delta*7.0)
	else:
		velocity.x = lerp(velocity.x,direction.x*get_speed(),delta*2.0)
		velocity.z = lerp(velocity.z,direction.z*get_speed(),delta*2.0)
	
	#head bob
	t_bob += delta *velocity.length()*float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	#set guncamera to the place of camera
	guncamera.global_transform = camera.global_transform
	guncamera.fov = camera.fov
	
	#FOV
	var velocity_clamped = clamp(velocity.length(),0.5,SPEED_RUN*2)	
	var target_fov = FOV_BASE +FOV_SPRINT_SCALE * velocity_clamped
	camera.fov = lerp(camera.fov,target_fov, delta*8.0)
	
	move_and_slide()

func die():
	queue_free()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQUENCY)*BOB_AMPLITUDE
	pos.x = cos(time * BOB_FREQUENCY/2)*BOB_AMPLITUDE/2
	return pos

func equip_weapon():
	
	
	#equip weapon
	if(inventory_selector<inventory.size()):
		equipped_id = inventory[inventory_selector].item_id
	else:
		inventory_selector = 0
	match inventory[inventory_selector].item_id:
		0:
			var new_gun = asset_gun.instantiate()
			camera.add_child(new_gun)
			new_gun.position = camera.position
			new_gun.rotate_y(deg_to_rad(90))
			new_gun.transform.origin = Vector3(1,-0.8,-1)
			new_gun.animation_player.play("change weapon in")
			new_gun.player = $"." #get the inventory of the player
			equipped = new_gun
		1:
			var new_shotgun = asset_shotgun.instantiate()
			camera.add_child(new_shotgun)
			new_shotgun.position = camera.position
			new_shotgun.rotate_y(deg_to_rad(90))
			new_shotgun.transform.origin = Vector3(1,-0.8,-1)
			new_shotgun.animation_player.play("change weapon in")
			new_shotgun.player = $"." #get the inventory of the player
			equipped = new_shotgun
		2:
			var new_sniper = asset_sniper.instantiate()
			camera.add_child(new_sniper)
			new_sniper.position = camera.position
			new_sniper.rotate_y(deg_to_rad(90))
			new_sniper.transform.origin = Vector3(1,-0.8,-1)
			new_sniper.animation_player.play("change weapon in")
			new_sniper.player = $"." #get the inventory of the player
			equipped = new_sniper
		-1: #nothing equipped
			pass
		_:
			equipped_id = -1
	#show gui for inventory
	display_inventory.visible = true
	inventory_timer.connect("timeout",_inventory_gui_timeout)
	inventory_timer.start()
	inventory_marker.visible = true
	match inventory_selector:
		0:
			inventory_marker.global_position.x = inv_slot_1.global_position.x
			inventory_marker.global_position.y = inv_slot_1.global_position.y
		1:
			inventory_marker.global_position.x = inv_slot_2.global_position.x
			inventory_marker.global_position.y = inv_slot_2.global_position.y
		2:
			inventory_marker.global_position.x = inv_slot_3.global_position.x
			inventory_marker.global_position.y = inv_slot_3.global_position.y
		_:
			inventory_marker.global_position.x = 0
			inventory_marker.global_position.y = 0
	
	match inventory[0].item_id:
		0:
			inv_slot_1.texture = icon_pistol
		1:
			inv_slot_1.texture = icon_shotgun
		2:
			inv_slot_1.texture = icon_sniper
		_:
			pass
	match inventory[1].item_id:
		0:
			inv_slot_2.texture = icon_pistol
		1:
			inv_slot_2.texture = icon_shotgun
		2:
			inv_slot_2.texture = icon_sniper
		_:
			pass
	match inventory[2].item_id:
		0:
			inv_slot_3.texture = icon_pistol
		1:
			inv_slot_3.texture = icon_shotgun
		2:
			inv_slot_3.texture = icon_sniper
		_:
			pass
			

func _on_bone_head_bodypart_hit(dmg):
	hp -= dmg
	set_rooted(1)


func _on_bone_body_bodypart_hit(dmg):
	hp -= dmg
	set_rooted(1)


	
# Ideally we would make `speed` only accessible via the getter and setter
func get_speed():
	if is_rooted:
		return 0;
	return speed

func set_speed(new_speed):
	speed = new_speed
	
func set_rooted(stun_duration_sec):
	is_rooted = true

	# Overlapping stuns are currently not supported, stun is cleared after timeout
	await get_tree().create_timer(stun_duration_sec).timeout
	
	is_rooted = false

func _inventory_gui_timeout():
	display_inventory.visible = false
	display_inventory.visible = false
