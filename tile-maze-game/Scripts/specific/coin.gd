extends Area2D

func _ready() -> void:
	area_entered.connect(coin_touched)


func _process(_delta: float) -> void:
	pass

func coin_touched(area : Area2D):
	if(area != null && area is Player):
		area.collect_coin()
		queue_free()
