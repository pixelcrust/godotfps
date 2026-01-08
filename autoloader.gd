extends Node

var player_health = 150
var player_position = Vector3(0,0,0)
var player_inventory = []
var player_rotation = Vector3(0,0,0)
var player_camera_rotation = Vector3(0,0,0)

var player_sensitivity = 0.05

#options
var music : float = 1
var track_playing : String = ''
var track_playing_position : float = 0.0
