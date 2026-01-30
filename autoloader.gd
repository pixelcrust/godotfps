extends Node

var player_health = 150
var player_position = Vector3(0,0,0)
var player_inventory = []
var player_rotation = Vector3(0,0,0)
var player_camera_rotation = Vector3(0,0,0)

var player_sensitivity = 0.05

#options
var music_enabled : bool = true
var current_track : int = 0
var current_time_stamp : float = 0
