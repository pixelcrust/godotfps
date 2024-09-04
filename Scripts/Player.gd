extends CharacterBody3D

var speed
const SPEED_CROUCH = 1.0
const SPEED_WALK = 3.0
const SPEED_RUN = 6.0
const JUMP_VELOCITY = 4.5
const SPEED_ADS = 0.5

var SENSITIVITY = Global.player_sensitivity

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
@onready var bone_head = $Head/bone_head
@onready var bone_body = $MeshInstance3D/bone_body

@onready var camera = $Head/Camera3D
@onready var guncamera = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D
@onready var raycast_interaction = $Head/Camera3D/raycast_interaction
@onready var collisionshape = $CollisionShape3D2
@onready var mesh = $MeshInstance3D
@onready var equipped = null
@onready var animation_player = $AnimationPlayer
@onready var node_flashlight = $Head/Camera3D/flashlight
@onready var raycast_aim = $Head/Camera3D/raycast_aim
@onready var raycast_head_place = $Head/Camera3D/raycast_head_place
@onready var bullet_spawn = $Head/Camera3D/bullet_spawn

@onready var audio_stream_player_3d = $AudioStreamPlayer3D



@onready var canvas_layer = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/CanvasGroup

@onready var display_ammo = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/CanvasGroup/display_ammo
@onready var display_hp = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/CanvasGroup/display_hp
@onready var display_interaction = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/CanvasGroup/display_interaction
@onready var display_crosshair = $Head/Camera3D/CanvasLayer/Crosshair


@onready var state_move = 0

#0.. walking
#1.. running
#2.. crouching
#3.. in air
#4.. ads

@onready var is_rooted = false
@onready var is_interacting = 0
@onready var outline_meshes = []
@onready var is_on_ladder = false
@onready var interacted_with_ladder = false
@onready var climbing_speed = 5
@onready var in_air_time = 0
@onready var in_air_time_till_dmg = 1.4
@onready var fall_dmg = 0
@onready var fall_stunned = 0
@onready var in_water = false
@onready var underwater_time = 0
@onready var under_water = false
@onready var shader_underwater = $Head/Camera3D/shader_underwater



@onready var equipped_id = -1 #what item in hand
#-1.. nothing
#0.. gun
#1.. shotgun

@onready var inventory = []
@onready var inventory_selector = 0
@onready var inventory_space = 3

#inventory slots and icons
@onready var display_inventory = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/CanvasGroup/display_inventory
@onready var inv_slot_1 = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/CanvasGroup/display_inventory/inv_1
@onready var inv_slot_2 = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/CanvasGroup/display_inventory/inv_2
@onready var inv_slot_3 = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/CanvasGroup/display_inventory/inv_3
@onready var icon_pistol = preload("res://Sprites/icons/icon_pistol_2.png")
@onready var icon_shotgun = preload("res://Sprites/icons/icon_shotgun.png")
@onready var icon_sniper = preload("res://Sprites/icons/icon_sniper.png")
const icon_knife = preload("res://Sprites/icons/icon_knife.png")
const icon_flashlight = preload("res://Sprites/icons/icon_flashlight.png")
const icon_grenade = preload("res://Sprites/icons/icon_grenade.png")
@onready var inventory_marker = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/CanvasGroup/display_inventory/inventory_marker
@onready var inventory_timer = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/CanvasGroup/display_inventory/inv_timer
@onready var help_text = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/CanvasGroup/help_text
var inventory_before = null

#gui
@onready var canvas_group: CanvasGroup = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/CanvasGroup


#text bubble variables
@onready var display_conversation = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/CanvasGroup/display_conversation
@onready var display_conversation_text = ""
@onready var conversation_timer = $Head/Camera3D/CanvasLayer/SubViewportContainer/SubViewport/Camera3D/CanvasGroup/display_conversation/conversation_timer


#preload equippment? move somewhere
@onready var asset_gun = preload("res://Scenes/gun.tscn")
@onready var asset_shotgun = preload("res://Scenes/shotgun.tscn")
@onready var asset_sniper = preload("res://Scenes/sniper.tscn")
@onready var asset_knife = preload("res://Scenes/knife.tscn")
@onready var asset_flashlight = preload("res://Scenes/flashlight.tscn")
const asset_grenade = preload("res://Scenes/grenade.tscn")

#preload weapons to be dropped
@onready var asset_drop_gun = preload("res://Scenes/gun_dropped.tscn")
@onready var  asset_drop_shotgun = preload("res://Scenes/shotgun_dropped.tscn")
@onready var  asset_drop_sniper = preload("res://Scenes/sniper_dropped.tscn")
const asset_drop_knife = preload("res://Scenes/knife_dropped.tscn")
const asset_drop_flashlight = preload("res://Scenes/flashlight_dropped.tscn")
const asset_drop_grenade = preload("res://Scenes/grenade_dropped.tscn")

#sound assets
const sound_flashlight_click = preload("res://Sounds/clicky button 13.wav")
const sound_land = preload("res://Sounds/unused/container of nuts 1.wav")
const sound_footstep_dirt_1 = preload("res://Sounds/footstep dirt 1.wav")
const sound_footstep_dirt_2 = preload("res://Sounds/footstep dirt 2.wav")
const sound_footstep_dirt_3 = preload("res://Sounds/footstep dirt 3.wav")
const sound_footstep_dirt_4 = preload("res://Sounds/footstep dirt 4.wav")
const sound_hurt_1 = preload("res://Sounds/oof 22.wav")
const sound_land_hurt = preload("res://Sounds/Bone Cracking 18.wav")
const SOUND_ITEM_PICKUP = preload("res://Sounds/velcro 1.wav")

@onready var hp_start = 150
@onready var hp = hp_start
@onready var flashlight = 0 #0.. off
@onready var flashlight_range = 200
@onready var state_before = 0

func _ready():
	#node_flashlight.spot_range = flashlight_range #sets the flashlight range in code for everywhere
	node_flashlight.spot_range = 0
	#adda gun to inventory
	
	#set respawn variables
	Global.player_health = hp
	Global.player_inventory = inventory
	Global.player_position = position
	Global.player_rotation = rotation
	"""
	inventory.append({
		"item_id": 0, #pistol
		"loaded": 7,
		"max_loaded": 7, # See above assignment.
		"spare_ammo": 100
	})
	
	inventory.append({
		"item_id": 1, #grenade
		"loaded": 1,
		"max_loaded": 2, # See above assignment.
		"spare_ammo": 20
	})
	inventory.append({
		"item_id": 2, #flashlight
		"loaded": 1,
		"max_loaded": 1, 
		"spare_ammo": 10
	})	

	
	
	inventory.append({
	"item_id": 0, #pistol
	"loaded": 7,
	"max_loaded": 7, # See above assignment.
	"spare_ammo": 100
	})
	inventory.append({
	"item_id": 4, #flashlight
	"loaded": 1,
	"max_loaded": 1, 
	"spare_ammo": 0
	})	
	
	inventory.append({
	"item_id": 5, #grenade
	"loaded": 1,
	"max_loaded": 1, # See above assignment.
	"spare_ammo": 0
	})
	
	inventory.append({
	"item_id": 3, #knife
	"loaded": 1,
	"max_loaded": 1, 
	"spare_ammo": 0
	})
	
	
	inventory.append({
	"item_id": 1, #shotgun
	"loaded": 2,
	"max_loaded": 2, 
	"spare_ammo": 4
	})
	inventory.append({
	"item_id": 2, #sniper
	"loaded": 1,
	"max_loaded": 1, 
	"spare_ammo": 10
	})
	inventory.append({
	"item_id": 0, #pistol
	"loaded": 7,
	"max_loaded": 7, # See above assignment.
	"spare_ammo": 100
	})
	"""
	inventory_before = inventory.duplicate(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	equip_weapon()

	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x*SENSITIVITY)
		camera.rotate_x(-event.relative.y*SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x,deg_to_rad(-89),deg_to_rad(90))
		
func _physics_process(delta):
	#restart scene
	if(Input.is_action_just_pressed("restart")):
		get_tree(). reload_current_scene()
		
	#start from checkpoint
	if(Input.is_action_just_pressed("key_restart_check_point")):
		hp = 0
		
	#if ded
	if hp <= 0:
		die()
	
	#heart pump
	if hp <= 20:
		canvas_group.pump = 1
	elif hp <= 50:
		canvas_group.pump = 0
	else:
		canvas_group.pump = 2
	
	# Add the gravity.
	#print("is on ladder: "+str(is_on_ladder)+" interacted with ladder: "+str(interacted_with_ladder))
	if not is_on_floor():
		if is_on_ladder == false or interacted_with_ladder == false:
			if not under_water:
				velocity.y -= gravity * delta
				state_move = 3
				in_air_time += delta
			else:
				velocity.y -= (gravity * delta)/ 3 
	else:
		if in_air_time > 0:
			if in_air_time > in_air_time_till_dmg:
				fall_dmg = floor(in_air_time)*20
				fall_stunned = floor(in_air_time)/10
				if fall_dmg >= 1:
					_on_bone_body_bodypart_hit(fall_dmg,fall_stunned)
					audio_stream_player_3d.stream = sound_land_hurt
					audio_stream_player_3d.play(0.0)
			#print("fall_dmg: "+str(fall_dmg))
			#audio_stream_player_3d.stream = sound_land
			#audio_stream_player_3d.play(0.0)
			in_air_time = 0
	#print("in air time: "+str(in_air_time))
	if in_water:
		in_air_time = 0
	#print("raycast point at: " +str(raycast_interaction.get_collider()))
	
	if raycast_head_place.is_colliding():
		#print(raycast_head_place.get_collider())
		if raycast_head_place.get_collider().is_in_group("liquid"):
			under_water = true
			#print("underwater!!")
		else:
			under_water = false
	else:
		under_water = false
	if under_water == true:
		underwater_time += 1
		shader_underwater.visible = true
	else:
		underwater_time = 0
		shader_underwater.visible = false
	
	if is_on_ladder == true and interacted_with_ladder == true:
		if(equipped != null):
			equipped.queue_free()
		in_air_time = 0
		velocity.y = 0
		if Input.is_action_pressed("key_jump"):
			velocity.y += climbing_speed
		if Input.is_action_pressed("key_crouch"):
			velocity.y -= climbing_speed
		#fall off when not looking at ladder
		if raycast_interaction.is_colliding() == false:
			interacted_with_ladder = false
		
	else:
		if(equipped == null):
			equip_weapon()
		state_move = 0
	
	if inventory.is_empty() == false:
		#display ammo
		display_ammo.visible = true
		display_ammo.clear()
		display_ammo.insert_text_at_caret(str(inventory[inventory_selector].loaded)+"/"+str(inventory[inventory_selector].spare_ammo))
	else:
		display_ammo.visible = false
		
	#display hp
	display_hp.clear()
	display_hp.insert_text_at_caret(str(hp))
	
	if Input.is_action_just_pressed("key_hide_ui"):
		if canvas_layer.visible == true:
			canvas_layer.visible = false
			
		else:
			canvas_layer.visible = true
			
	if Input.is_action_just_pressed("key_escape"):
		_conversation_timeout()
		
	#turn on flashlight without it in hand
	if Input.is_action_just_pressed("key_use_flashlight"):
		for n in inventory:
			print(n)
			if(n.item_id == 4): #should only be able if  in invenotry
				audio_stream_player_3d.stream = sound_flashlight_click
				audio_stream_player_3d.play(0.0)
				if flashlight == 0:
					node_flashlight.spot_range = 0
					flashlight = 1
				else:
					node_flashlight.spot_range = flashlight_range
					flashlight = 0
			
	# Handle Jump.
	if Input.is_action_just_pressed("key_jump") and (is_on_floor() or in_water):
		if is_on_ladder == false or interacted_with_ladder == false:
			if in_water:
				velocity.y = JUMP_VELOCITY/2
			else:
				velocity.y = JUMP_VELOCITY
	
	#run
	if (Input.is_action_pressed("key_run") && (state_move < 2)):
		set_speed(SPEED_RUN)
		state_move = 1
		
	elif(Input.is_action_pressed("key_crouch") && (state_move != 2)):
		set_speed(SPEED_CROUCH)
		state_move = 2
	elif Input.is_action_pressed("key_ads") && (state_move != 3):
		#state_before = state_move
		state_move = 4
		if equipped != null:
			equipped.ads = 1
			if equipped_id != 2: #dont hide crossair of sniper
				#display_crosshair.visible = false
				pass
			#state_move = state_before dont know where thisS
	else:
		set_speed(SPEED_WALK)
		if equipped != null:
			equipped.ads = 0
			display_crosshair.visible = true
		state_move = 0
	

	if(Input.is_action_pressed("key_help")):
		help_text.visible = true
		#hp -= 30
	else:
		help_text.visible = false
		
	# Start interaction
	if Input.is_action_just_pressed("Interact")  and raycast_interaction.is_colliding():
		if raycast_interaction.get_collider().is_in_group("interactable"):
			var obj_interaction_time = raycast_interaction.get_collider().object.get_interaction_time()
			if obj_interaction_time > .4:
				display_interaction.visible = true
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
				raycast_interaction.get_collider().object.use()
				is_interacting = 0
	
	# Stop interaction
	else:
		is_interacting = 0
		display_interaction.visible = false

	#outline
	if raycast_interaction.is_colliding():
		if raycast_interaction.get_collider() != null:
			if raycast_interaction.get_collider().is_in_group("interactable"):
				set_outline_on(raycast_interaction.get_collider())
			if raycast_interaction.get_collider().is_in_group("interactable") == false:
				set_outline_off()
	else:
		if outline_meshes.is_empty() == false:
			set_outline_off()
			
	#swap weapon
	if Input.is_action_just_pressed("key_next_weapon"):
		
		if equipped != null:
			if equipped.animation_player.is_playing():
				pass
			else:
				equipped.animation_player.play("change weapon out") #this does not work
			#wait here for animation out
			await get_tree().create_timer(.51).timeout 
			equipped.queue_free() 
		inventory_selector += 1
		equip_weapon()
		print("waepon equipped: "+str(equipped_id))
	#drop weapon
	if Input.is_action_just_pressed("key_drop_weapon") && equipped_id != -1:
		drop_weapon()
	
	#shoot
	if(Input.is_action_just_pressed("key_shoot")):
		if equipped_id != -1:
			#print("player_head_place: "+ str(bullet_spawn.global_position))
			var victim = null
			if raycast_aim.is_colliding() == true:
				victim = raycast_aim.get_collision_point()
				#bullet_spawn.look_at(victim)
			equipped.shoot(inventory_selector,bullet_spawn,true,victim)
			"""if (inventory[inventory_selector].loaded == 0 and inventory[inventory_selector].spare_ammo == 0 and equipped.is_in_group("consumeable")):
				print("consumeable empty")
				equipped.queue_free()
				inventory_before.remove_at(inventory_selector)
				inventory.remove_at(inventory_selector)
				equip_weapon()"""
		else:
			pass
	
	#reload
	if(Input.is_action_just_pressed("key_reload")):
		if equipped_id != -1:
			equipped.reload(inventory_selector)
		else:
			pass
	
	#inspect weapon
	if(Input.is_action_just_pressed("key_inspect_weapon")):
		if equipped_id != -1:
			equipped.inspect()
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
	if state_move != 4:
		var velocity_clamped = clamp(velocity.length(),0.5,SPEED_RUN*2)	
		var target_fov = FOV_BASE +FOV_SPRINT_SCALE * velocity_clamped
		camera.fov = lerp(camera.fov,target_fov, delta*8.0)
	
	move_and_slide()

func die():
	position = Global.player_position
	hp = Global.player_health
	rotation = Global.player_rotation
	camera.rotation = Global.player_camera_rotation
	
	#get_tree().reload_current_scene()
	#queue_free()
	pass

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQUENCY)*BOB_AMPLITUDE
	pos.x = cos(time * BOB_FREQUENCY/2)*BOB_AMPLITUDE/2
	return pos


func start_conversation(wait_time):
	print(str(wait_time))
	conversation_timer.start()
	conversation_timer.connect("timeout",_conversation_timeout)
	conversation_timer.wait_time = wait_time
	display_conversation.visible = true
	
func equip_weapon():
	#equip weapon
	if(inventory_selector<inventory.size()):
		equipped_id = inventory[inventory_selector].item_id
		print("item_id: "+str(inventory.front().item_id))
	elif inventory.is_empty() == false:
		
		inventory_selector = 0
		equipped_id = inventory[inventory_selector].item_id
		
	if inventory.is_empty():
		equipped_id = -1
	else:
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
				new_shotgun.transform.origin = Vector3(0.4,-0.6,-1.4)
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
			3:
				var new_knife = asset_knife.instantiate()
				camera.add_child(new_knife)
				new_knife.position = camera.position
				new_knife.rotate_y(deg_to_rad(90))
				new_knife.transform.origin = Vector3(1,-0.8,-1)
				new_knife.animation_player.play("change weapon in")
				new_knife.player = $"."
				equipped = new_knife
			4:
				var new_flashlight = asset_flashlight.instantiate()
				camera.add_child(new_flashlight)
				new_flashlight.position = camera.position
				new_flashlight.rotate_y(deg_to_rad(90))
				new_flashlight.transform.origin = Vector3(1,-0.8,-1)
				new_flashlight.animation_player.play("change weapon in")
				new_flashlight.player = $"."
				new_flashlight.spotlight_range = flashlight_range
				new_flashlight.on = flashlight
				equipped = new_flashlight
			5:
				var new_grenade = asset_grenade.instantiate()
				camera.add_child(new_grenade)
				new_grenade.position = camera.position
				new_grenade.rotate_y(deg_to_rad(90))
				new_grenade.transform.origin = Vector3(1,-0.8,-1)
				new_grenade.animation_player.play("change weapon in")
				new_grenade.player = $"."
				equipped = new_grenade
			-1: #nothing equipped
				pass
			_:
				equipped_id = -1
	#show gui for inventory
	display_inventory.visible = true
	inventory_timer.connect("timeout",_inventory_gui_timeout)
	inventory_timer.start()
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
	
	if inventory_before != inventory:
		audio_stream_player_3d.stream = SOUND_ITEM_PICKUP
		audio_stream_player_3d.play(0.0)
		inventory_before = inventory.duplicate(true)
		
	if inventory.is_empty() == false:
		inventory_marker.visible = true
		match inventory[0].item_id:
			0:
				inv_slot_1.texture = icon_pistol
			1:
				inv_slot_1.texture = icon_shotgun
			2:
				inv_slot_1.texture = icon_sniper
			3:
				inv_slot_1.texture = icon_knife
			4:
				inv_slot_1.texture = icon_flashlight
			5:
				inv_slot_1.texture = icon_grenade
				#grenade icon
			-1: 
				inv_slot_1.texture = null
			_:
				pass

				
		if len(inventory) >1:
			match inventory[1].item_id:
				0:
					inv_slot_2.texture = icon_pistol
				1:
					inv_slot_2.texture = icon_shotgun
				2:
					inv_slot_2.texture = icon_sniper
				3:
					inv_slot_2.texture = icon_knife
				4:
					inv_slot_2.texture = icon_flashlight
				5:
					inv_slot_2.texture = icon_grenade
				_:
					pass
		else:
			inv_slot_2.texture = null
			
		if len(inventory) >2:
			match inventory[2].item_id:
				0:
					inv_slot_3.texture = icon_pistol
				1:
					inv_slot_3.texture = icon_shotgun
				2:
					inv_slot_3.texture = icon_sniper
				3:
					inv_slot_3.texture = icon_knife
				4:
					inv_slot_3.texture = icon_flashlight
				5:
					inv_slot_3.texture = icon_grenade
				_:
					pass
		else:
			inv_slot_3.texture = null
	else:
		inv_slot_1.texture = null
		inventory_marker.visible = false
	canvas_group.ammo_choose()

func _on_bone_head_bodypart_hit(dmg,time_rooted):
	hp -= dmg
	audio_stream_player_3d.stream = sound_hurt_1
	audio_stream_player_3d.play(0.0)
	if(time_rooted > 0):
		set_rooted(time_rooted)

func _on_bone_body_bodypart_hit(dmg,time_rooted):
	hp -= dmg
	audio_stream_player_3d.stream = sound_hurt_1
	audio_stream_player_3d.play(0.0)
	if(time_rooted > 0):
		set_rooted(time_rooted)

func drop_weapon():
	equipped.queue_free()

	match inventory[inventory_selector].item_id:
		0:
			print("dropped gun")
			var new_dropped_gun = asset_drop_gun.instantiate()
			new_dropped_gun.position = raycast_interaction.global_position -transform.basis.z*1.5
			new_dropped_gun.transform.basis = global_transform.basis
			get_tree().root.get_children()[0].add_child(new_dropped_gun)
			new_dropped_gun.loaded = inventory[inventory_selector].loaded
			new_dropped_gun.spare_ammo = inventory[inventory_selector].spare_ammo
			new_dropped_gun.rigid_body.apply_impulse(-transform.basis.z *4)
		1:
			print("dropped shotgun")
			var new_dropped_shotgun = asset_drop_shotgun.instantiate()
			new_dropped_shotgun.position = raycast_interaction.global_position -transform.basis.z*1.5
			new_dropped_shotgun.transform.basis = global_transform.basis
			get_tree().root.get_children()[0].add_child(new_dropped_shotgun)
			new_dropped_shotgun.loaded = inventory[inventory_selector].loaded
			new_dropped_shotgun.spare_ammo = inventory[inventory_selector].spare_ammo
			new_dropped_shotgun.rigid_body.apply_impulse(-transform.basis.z *4)
		2:
			print("dropped sniper")
			var new_dropped_sniper = asset_drop_sniper.instantiate()
			new_dropped_sniper.position = raycast_interaction.global_position -transform.basis.z*1.5
			new_dropped_sniper.transform.basis = global_transform.basis
			new_dropped_sniper.loaded = inventory[inventory_selector].loaded
			new_dropped_sniper.spare_ammo = inventory[inventory_selector].spare_ammo
			get_tree().root.get_children()[0].add_child(new_dropped_sniper)
			new_dropped_sniper.rigid_body.apply_impulse(-transform.basis.z *4)
		3:
			print("dropped knife")
			var new_dropped_knife = asset_drop_knife.instantiate()
			new_dropped_knife.position = raycast_interaction.global_position -transform.basis.z*0.5
			new_dropped_knife.transform.basis = global_transform.basis
			get_tree().root.get_children()[0].add_child(new_dropped_knife)
			new_dropped_knife.rigid_body.apply_impulse(-transform.basis.z *4)
		4:
			print("dropped flashlight")
			var new_dropped_flashlight = asset_drop_flashlight.instantiate()
			new_dropped_flashlight.position = raycast_interaction.global_position -transform.basis.z*0.5
			new_dropped_flashlight.transform.basis = global_transform.basis
			get_tree().root.get_children()[0].add_child(new_dropped_flashlight)
			new_dropped_flashlight.rigid_body.apply_impulse(-transform.basis.z *4)
			node_flashlight.spot_range = 0
		5:
			print("dropped grenade")
			var new_dropped_grenade = asset_drop_grenade.instantiate()
			new_dropped_grenade.position = raycast_interaction.global_position -transform.basis.z*0.5
			new_dropped_grenade.transform.basis = global_transform.basis
			get_tree().root.get_children()[0].add_child(new_dropped_grenade)
			new_dropped_grenade.loaded = inventory[inventory_selector].loaded
			new_dropped_grenade.spare_ammo = inventory[inventory_selector].spare_ammo
			new_dropped_grenade.rigid_body.apply_impulse(-transform.basis.z *4)
		-1:
			pass
		_:
			pass
	inventory_before.remove_at(inventory_selector)
	inventory.remove_at(inventory_selector)
	equip_weapon()
	
func heal(heal_amount):
	hp += heal_amount
	
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
	
func _conversation_timeout():
	display_conversation.visible = false
	
func set_outline_on(object):
	#loop for array thats returned
	if outline_meshes != object.get_outline_meshes():
		set_outline_off()
	outline_meshes = object.get_outline_meshes()
	for n in outline_meshes:
		n.outline_mesh.visible = true
	#last_object_outlined = object
	#set interactable objects outline to true
	
func set_outline_off():
	for n in outline_meshes:
		#print(n)
		if n != null:
			n.outline_mesh.visible = false
	#outline_meshes.clear()
	#print(outline_meshes)
	#print("array end")
