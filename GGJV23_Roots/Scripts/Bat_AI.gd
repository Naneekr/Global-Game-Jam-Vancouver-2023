extends Node2D

const MAX_HP = 40

var move_speed = 0.6
var attack_damage = 1
var current_hp = 40
var holy_stacks = 0

var target_dir = Vector2(0,0)
var flipped = true
var attacking = false
var attack_range = 30

var player_position = Vector2(320, 320)

var mat: ShaderMaterial
var dissolve_amount = 1

@onready var sprite = $Sprite2D
@onready var anim = $Sprite2D/AnimationPlayer
@onready var hurtbox = $AnimatableBody2D/CollisionShape2D
@onready var sigbus = $"/root/SignalBus"

# @onready var player = $somefilepathtotheplayer





# Called when the node enters the scene tree for the first time.
func _ready():
	sigbus.holy_burst.connect(_on_holy_burst)

	mat = sprite.material
	mat.set_shader_parameter("dissolve_value", dissolve_amount)
	target_dir.x = self.global_position.x - player_position.x
	if target_dir.x <= 0 : flipped = false
	else : flipped = true
	_chase()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if attacking == false: _chase()
	else: _attack()
	
	if holy_stacks > 0:
		current_hp -= MAX_HP*(0.2 + 0.1*(holy_stacks-1))*delta
		$HBarEmpty.set_point_position(1, Vector2(10 - (20*(1-current_hp/MAX_HP)), 0))
	if current_hp <= 0:
		_die(delta)
		holy_stacks = 0

func _chase():
	attacking = false
	
	var movement = move_speed * clampf(target_dir.x, -1, 1)
	translate(Vector2(movement,0))
	
	if flipped: sprite.set_flip_h(true)
	else: sprite.set_flip_h(false)
	anim.play("Move")
	if abs(self.position.x - player_position.x) <= attack_range : _attack()
	

func _attack():
	attacking = true
	anim.play("Attack")

func _send_attack_signal():
	sigbus.emit_signal("enemy_attack", attack_damage)
	
func _on_holy_burst(_level):
	holy_stacks += 1

func _die(delta):
	anim.stop()
	dissolve_amount -= delta
	mat.set_shader_parameter("dissolve_value", dissolve_amount)
	if dissolve_amount <= 0 : self.queue_free()
	
