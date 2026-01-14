extends CharacterBody2D
@export var vertical_vel := 8
@export var horizontal_vel := 8

func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	if Input.is_action_just_pressed("Up"):
		position.y -= vertical_vel
	if(Input.is_action_just_pressed("Down")):
		position.y += vertical_vel
	if(Input.is_action_just_pressed("Left")):
		position.x -= horizontal_vel
	if(Input.is_action_just_pressed("Right")):
		position.x += horizontal_vel
