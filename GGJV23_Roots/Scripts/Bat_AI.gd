extends Node2D

var move_speed = 2
var attack_damage = 2
var health = 40

var target_dir = Vector2(-0.001,0)
var flipped = true
var attacking = false
var attack_distance = 250
var travel_distance = 0

@onready var sprite = $Sprite2D
@onready var anim = $Sprite2D/AnimationPlayer
@onready var hurtbox = $AnimatableBody2D/CollisionShape2D
# @onready var player = $somefilepathtotheplayer

signal enemy_attack



# Called when the node enters the scene tree for the first time.
func _ready():
	#target_dir.x = player.position.x - self.position.x
	if target_dir.x <= 0 : flipped = false
	else : flipped = true
	_chase()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if attacking == false: _chase()
	else: _attack()

func _chase():
	attacking = false
	var movement = move_speed*(signf(target_dir.x))
	translate(Vector2(movement,0))
	travel_distance += abs(movement)
	
	if flipped: sprite.set_flip_h(true)
	else: sprite.set_flip_h(false)
	anim.play("Move")
	if travel_distance >= attack_distance : _attack()
	

func _attack():
	attacking = true
	anim.play("Attack")

func _send_attack_signal():
	emit_signal("enemy_attack")
	
func _on_holy_burst(_level):
	return
