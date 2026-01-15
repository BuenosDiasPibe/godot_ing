class_name Player
extends Area2D

var _tile_size : int = 8
@export var raycast : RayCast2D
@export var damageDetector : Area2D

var life : int = 1
var coin : int = 0

var _inputs = {"Right": Vector2.RIGHT,
			"Left": Vector2.LEFT,
			"Up": Vector2.UP,
			"Down": Vector2.DOWN}

var _initial_pos : Vector2


func _ready() -> void:
	_initial_pos = position
	damageDetector.body_entered.connect(get_damaged)
	damageDetector.area_entered.connect(get_damaged)

func _process(_delta: float) -> void:
	# spiritually stealed from https://kidscancode.org/godot_recipes/4.x/2d/grid_movement/index.html
	for direction in _inputs.keys():
		if Input.is_action_just_pressed(direction):
			raycast.target_position = _inputs[direction] * _tile_size
			raycast.force_raycast_update() # now it updates from "process" instead of "physics process"
			if(!raycast.is_colliding()):
				position += _inputs[direction] * _tile_size
	if(life <= 0):
		position = _initial_pos
		life = 1

func collect_coin() -> void:
	coin+=1
	print(coin)

func get_damaged(_not_used) -> void:
	life -=1
	print("life: " + str(life))
