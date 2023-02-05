extends Node2D

const MAX_HP = 100

var move_speed = 2
var attack_damage = 2
var current_hp = 100
var holy_stacks = 0

var target_dir = Vector2(12800,0)
var flipped = false
var attacking = false

var mat: ShaderMaterial
var dissolve_amount = 1

@onready var sprite = $Sprite2D
@onready var anim = $Sprite2D/AnimationPlayer
@onready var hurtbox = $AnimatableBody2D/CollisionShape2D
# @onready var player = $somefilepathtotheplayer

signal enemy_attack



# Called when the node enters the scene tree for the first time.
func _ready():
	mat = sprite.material
	mat.set_shader_parameter("dissolve_value", dissolve_amount)
	#target_dir.x = player.position.x - self.position.x
	if target_dir.x >= 0 : flipped = false
	else : flipped = true
	_chase()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if attacking == false: _chase()
	else: _attack()
	
	if holy_stacks > 0:
		current_hp -= MAX_HP*(0.2 + 0.1*(holy_stacks-1))*delta
		$HBarEmpty.set_point_position(1, Vector2(25 - (50*(1-current_hp/MAX_HP)), 0))
	if current_hp <= 0:
		_die(delta)
		holy_stacks = 0

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
	emit_signal("enemy_attack", attack_damage)
	
func _on_holy_burst(_level):
	holy_stacks += 1

func _die(delta):
	anim.stop()
	dissolve_amount -= delta
	mat.set_shader_parameter("dissolve_value", dissolve_amount)
	if dissolve_amount <= 0 : self.queue_free()
