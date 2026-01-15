extends PathFollow2D

@export var _progress : float = 0.2

func _process(delta: float) -> void:
	progress_ratio = fmod(progress_ratio+_progress*delta, 1)
