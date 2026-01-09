extends AnimatedSprite2D
var direction : Vector2 = Vector2.ZERO
var velocity : int = 200
var colorChanging : int = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown", 0)
	if(direction.x < 0):
		flip_h = true
	else: flip_h = false
	position += direction*velocity*delta
