extends Node2D

var map_size = Vector2i(11,6)
var current_cell = Vector2i(0,0)
var mouse_pos = Vector2(0,0)
var energy = 5000
var surroundings = [Vector2i(0,0)]
var surroundings_atlas = [Vector2i(0,0)]

@onready var ground = $Ground
@onready var roots = $Roots

func _ready():
	map_size.x = DisplayServer.screen_get_size().x
	make_grass()


func make_grass():
	for x in map_size.x:
		for y in map_size.y:
			ground.set_cell(0,Vector2i(x,y+5),0, Vector2i(1,0))
	
	ground.set_cells_terrain_connect(0, ground.get_used_cells(0), 0, 0)
	

func _input(event):
	if event is InputEventMouseButton && event.is_pressed():
		if energy >= 1:
			make_roots()
		
		
	

func make_roots():
	mouse_pos = get_local_mouse_position()/roots.cell_quadrant_size
	roots.set_cell(0, mouse_pos, 2, Vector2i(0,3))
	roots.set_cells_terrain_connect(0, roots.get_used_cells(0), 0, 0)
	energy -= 1
