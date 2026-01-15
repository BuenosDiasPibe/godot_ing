extends Area2D
# spiritually stealed from https://kidscancode.org/godot_recipes/4.x/2d/grid_movement/index.html
var tile_size : int = 8
@export var raycast : RayCast2D

var inputs = {"Right": Vector2.RIGHT,
			"Left": Vector2.LEFT,
			"Up": Vector2.UP,
			"Down": Vector2.DOWN}

func _process(_delta: float) -> void:
	for direction in inputs.keys():
		if Input.is_action_just_pressed(direction):
			raycast.target_position = inputs[direction] * tile_size
			raycast.force_raycast_update() # now it updates from "process" instead of "physics process"
			if(!raycast.is_colliding()):
				position += inputs[direction] * tile_size
