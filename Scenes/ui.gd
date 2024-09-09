extends CanvasGroup

@onready var icon_ammo: Sprite2D = $icon_ammo
@onready var icon_heart: Sprite2D = $icon_heart

@onready var player: CharacterBody3D = $"../../../../../../.."
@onready var gui_wiggle_timer: Timer = $gui_wiggle_timer

var icon_bullet_pistol = preload("res://Sprites/pistol_bullet_icon.png")
var icon_shell = preload("res://Sprites/shotgun_shell_icon.png")
var icon_explosion = preload("res://Sprites/explosion_icon.png")
var max_angle_rotation = 25
var shaking = 2 #0starting 1shaking 2not shaking
var going_right = true
var rotation_duration = .7
var shake_speed = 5

var pump_speed_fast = 2
var pump_speed_medium = 1
var pump_speed_slow = .5
var pump_size_fast = 2
var pump_size_medium = 1
var pump_size_slow = .5
var pump_speed = .3
var pump_size = .3
var growing = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gui_wiggle_timer.wait_time = rotation_duration
	icon_ammo.visible = false
	ammo_choose()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shaking != 2:
		ammo_shake(delta)
	
	heart_pump(delta)


func heart_pump(delta):
		#heart pump
	if player.hp <= 20:
		pump_speed = pump_speed_fast
		pump_size = pump_size_fast
	elif player.hp <= 50:
		pump_speed = pump_speed_medium
		pump_size = pump_size_medium
	else:
		pump_speed = pump_speed_slow
		pump_size = pump_size_slow
	
	if growing == 1:
		icon_heart.scale += Vector2(pump_speed*delta,pump_speed*delta)
		if icon_heart.scale.x >= 1+ (pump_size):
			growing = 0
	else:
		icon_heart.scale -= Vector2(pump_speed*delta,pump_speed*delta)
		if icon_heart.scale.x <= 1- (pump_size):
			growing = 1

func ammo_shake(delta):
	print("wiggle_timer: "+str(gui_wiggle_timer.time_left))
	print("rotation: "+str(rad_to_deg(icon_ammo.rotation)))
		
	if shaking == 0:
		gui_wiggle_timer.start()
		shaking = 1
	elif shaking == 1:
		if going_right == true:
			icon_ammo.rotation += shake_speed*delta
			if icon_ammo.rotation >= deg_to_rad(max_angle_rotation):
				going_right = false
		else:
			icon_ammo.rotation -= shake_speed*delta
			if icon_ammo.rotation <= deg_to_rad(-max_angle_rotation):
				going_right = true
	else:
		pass
	
func ammo_choose():
	match player.equipped_id:
		0:
			icon_ammo.visible = true
			icon_ammo.texture = icon_bullet_pistol
		1:
			icon_ammo.visible = true
			icon_ammo.texture = icon_shell
		5:
			icon_ammo.visible = true
			icon_ammo.texture = icon_explosion
		_:
			icon_ammo.visible = false
			icon_ammo.texture = null
			
func _on_gui_wiggle_timer_timeout() -> void:
	icon_ammo.rotation = 0
	shaking = 2
	
