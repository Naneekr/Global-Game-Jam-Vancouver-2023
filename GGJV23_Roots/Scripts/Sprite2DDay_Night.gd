extends Sprite2D

var sprite = self
var time = 0
var day_length = 25

func _process(delta):
	time += delta/day_length
	sprite.self_modulate = Color(1,1,1,abs(cos(time)))
	if time > 2*PI: time = 0
