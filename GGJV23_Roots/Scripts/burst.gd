extends Panel

var ripple_time = 0.0
var mat: ShaderMaterial
var burst_is_active = false


# Called when the node enters the scene tree for the first time.
func _ready():
	mat = self.material


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if burst_is_active:
		ripple_time += delta*1.5
		mat.set_shader_parameter("RTIME", ripple_time)
		if ripple_time >= 3.0:
			burst_is_active = false


func _on_holy_burst(_level):
	ripple_time = 0.0
	burst_is_active = true
	print_debug("Wow holy burst")
