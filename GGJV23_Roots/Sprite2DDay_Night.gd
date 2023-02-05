extends Sprite2D

var sprite = self
var time = 0
var day_length = 3

func _process(delta):
	time += delta * 1/day_length
	sprite.self_modulate = Color(1,1,1,cos(time))
	if time > PI: time = 0
