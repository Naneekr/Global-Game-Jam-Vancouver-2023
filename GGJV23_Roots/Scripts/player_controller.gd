extends Node

#Signals
signal holy_burst

#Constants
var TREE_SIZES
const MAX_LEAVES = [3, 8, 16]
const MAX_ROOTS  = [4, 8, 12]
const HOLY_BURST_COST = 1
var leaf_vis
var root_vis
const TICK_GOAL = 2.0
var root_sprite

#Tree stats
var size_level            = 0
var max_hp                = 10
var current_leaves        = 1
var current_total_roots   = 1
var current_active_roots  = 1
var current_hp            = 10
var current_water         = 0
var current_sun           = 0 
var current_sugar         = 0

#System vars
var progress_to_tick = 0

#Default Funcs
func _ready():
	TREE_SIZES = [$Tree/Size_1, $Tree/Size_2, $Tree/Size_3]
	leaf_vis = [
		[$Tree/Size_1/Leaf1, $Tree/Size_1/Leaf2, $Tree/Size_1/Leaf3]
	]
	root_vis = [
		[$Tree/RootBase/Root_1, $Tree/RootBase/Root_2, $Tree/RootBase/Root_3, $Tree/RootBase/Root_4]
	]
	root_sprite = $Tree/RootBase/Sprite2D
	root_sprite.frame = size_level
	TREE_SIZES[size_level].visible = true
	toggle_leaves()
	toggle_roots()
	
func _process(delta):
	progress_to_tick += delta
	
	if progress_to_tick >= TICK_GOAL:
		progress_to_tick = 0
		current_sun += current_leaves
		current_water += current_active_roots
		update_ui()
	
func toggle_leaves():
	for i in current_leaves:
		leaf_vis[size_level][i].visible = true
		
func toggle_roots():
	for i in current_total_roots:
		root_vis[size_level][i].visible = true
		
func update_ui():
	$MainControl/VBoxContainer/HBoxContainer/Label2.text = str(current_sun)
	$MainControl/VBoxContainer/HBoxContainer2/Label2.text = str(current_water)
	$MainControl/VBoxContainer/HBoxContainer3/Label2.text = str(current_sugar)

#Signal Callbacks
##Basic buttons
func _on_hb_button_pressed():
	if current_sun >= HOLY_BURST_COST:
		current_sun -= HOLY_BURST_COST
		emit_signal("holy_burst", 1)
		update_ui()
	
func _on_wh_button_pressed():
	if current_water >= 3:
		current_water -= 3
		current_hp += 2
		if current_hp > max_hp:
			current_hp = max_hp
		update_ui()
	
func _on_sg_button_pressed():
	if current_sun >= 3 && current_water >= 3:
		current_sugar += 1
		current_sun -= 3
		current_water -= 3
		update_ui()

##Advanced Attacks
func _on_ls_button_pressed():
	current_leaves -= 1
	#Shoot leaf...
	
##Upgrades
func _on_growleaf_button_pressed():
	if current_sugar >= 2 && current_leaves < MAX_LEAVES[size_level]:
		current_leaves += 1
		current_sugar -= 2
		toggle_leaves()
		update_ui()
	
func _on_grow_root_button_pressed():
	if current_sugar >= 6 && current_total_roots < MAX_ROOTS[size_level]:
		current_total_roots += 1
		current_active_roots += 1
		current_sugar -= 6
		toggle_roots()
		update_ui()
	
func _on_grow_tree_button_pressed():
	pass
	
func _on_enemy_attack(damage):
	current_hp -= damage
	
	if current_hp < damage:
		pass #gameover


