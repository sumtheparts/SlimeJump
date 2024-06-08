extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func place_slime():
	var pos = position
	var  tile_pos = (pos / 20)
	set_cell(, tile_pos,1, 0,4)
