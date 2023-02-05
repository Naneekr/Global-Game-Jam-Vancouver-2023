extends Node2D

var move_speed = 2
var attack_damage = 2
var health = 40

var target_dir = Vector2(12800,0)
var flipped = false
var attacking = false

@onready var sprite = $Sprite2D
@onready var anim = $Sprite2D/AnimationPlayer
@onready var hurtbox = $AnimatableBody2D/CollisionShape2D
# @onready var player = $somefilepathtotheplayer

signal enemy_attack



# Called when the node enters the scene tree for the first time.
func _ready():
	#target_dir.x = player.position.x - self.position.x
	if target_dir.x >= 0 : flipped = false
	else : flipped = true
	_chase()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if attacking == false: _chase()
	else: _attack()

func _chase():
	attacking = false
	translate(Vector2(move_speed*(signf(target_dir.x)),0))
	target_dir.x = target_dir.x - self.position.x
	if flipped: sprite.set_flip_h(true)
	else: sprite.set_flip_h(false)
	anim.play("Move")
	if target_dir.x < 5 : _attack()
	

func _attack():
	attacking = true
	anim.play("Attack")

func _send_attack_signal():
	emit_signal("enemy_attack")
	
func _on_holy_burst(_level):
	return
