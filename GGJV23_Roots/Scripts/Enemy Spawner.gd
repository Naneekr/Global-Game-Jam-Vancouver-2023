extends Node2D

var skele = preload("res://Scenes/skele.tscn")
var bat = preload("res://Scenes/bat.tscn")

var spawned_enemy


@onready var spawn_pointL = $Spawn_Point_L
@onready var spawn_pointR = $Spawn_Point_R

var wave_timer = 5
var wave_time_elapsed = 0
var total_time_elapsed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	total_time_elapsed += delta*0.1
	wave_time_elapsed += delta
	wave_timer = 10/(total_time_elapsed)
	if wave_timer <= 0.1: wave_timer = 0.1
	if wave_time_elapsed >= wave_timer:
		spawn()

func spawn():
	
	wave_time_elapsed = 0
	var coin = randi_range(0,1)
	var coin2 = randi_range(0,1)
	print(coin , coin2)
	
	if coin == 0 : 
		spawned_enemy = skele.instantiate()
		add_child(spawned_enemy)
		if coin2 == 0:
			spawned_enemy.set_position(spawn_pointL.position)
		if coin2 == 1:
			spawned_enemy.set_position(spawn_pointR.position)
			
	if coin == 1 :
		spawned_enemy = bat.instantiate()
		add_child(spawned_enemy)
		if coin2 == 0:
			spawned_enemy.set_position(Vector2(spawn_pointL.position.x, 215))
		if coin2 == 1:
			spawned_enemy.set_position(Vector2(spawn_pointR.position.x, 215))
	
