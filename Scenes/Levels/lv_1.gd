extends Node2D

@onready var player = $Player
@onready var tile_set = $TileSets/Playspace_tiles
var slime_bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	place_slime()
	pass

func place_slime():
	
	var pos = player.position
	var tile_pos = (tile_set.local_to_map(pos)) 
	var tile_pos_offset = tile_pos + Vector2i(0,1)
	var tile_matched_pos = tile_set.map_to_local(tile_pos)
	if tile_set.get_cell_tile_data(1,tile_pos_offset,0) != null and tile_set.get_cell_atlas_coords(2,tile_pos_offset,0) != Vector2i(0,4) and slime_bool == true:
	#if tile_set.get_cell_tile_data(1,tile_pos_offset,0) != null and slime_bool == true:
		tile_set.set_cell(2, tile_pos_offset ,1, Vector2i (0,4))
		#construct slime area w collisionshape
		#output signal on body entered
		var slime_area = Area2D.new()
		var slime_col = CollisionShape2D.new()
		var s_col_box = RectangleShape2D.new()
		
		add_child(slime_area)
		slime_area.add_child(slime_col)
		s_col_box.set_size(Vector2(20,2))
		slime_col.set_shape(s_col_box)
		slime_col.position = tile_matched_pos + Vector2(0,10)
		slime_area.collision_layer = 2
		slime_area.collision_mask = 2
		slime_area.monitoring = true
		slime_area.body_entered.connect(_on_slime_body_entered)
		#await get_tree().create_timer(10).timeout
		#$TileSets/Playspace_tiles.erase_cell(2,tile_pos)
	else:
		pass


func _on_player_ground_timeout_true():
	slime_bool = true
	pass # Replace with function body.


func _on_player_ground_timeout_false():
	slime_bool = false
	pass # Replace with function body.

func _on_slime_body_entered(body):
	body.in_slime()
	pass
	
func _on_slime_body_exited(body):
	body.leave_slime()
	pass
