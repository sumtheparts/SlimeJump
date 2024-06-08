extends Node2D

@export var spring_const = 0.015
@export var dampening = 0.05
@export var spread = 0.0002

var springs = []
var passes = 8

@export var dis_between_springs = 32
@export var spring_num = 6

@onready var water_spring = load("res://water_spring.tscn")

@export var depth = -100
var target_hight = global_position.y
var bottom = target_hight - depth

@onready var water_polygon = $water_polygon
@onready var water_border = $water_border
@export var border_thickness = 10

@onready var collision_shape = $water_body_area/CollisionShape2D
@onready var water_body_area = $water_body_area

func _ready():
	#water_border.width = border_thickness
	
	for i in range(spring_num):
		var x_pos =(dis_between_springs * i)
		var w = water_spring.instantiate()
	
		add_child(w)
		springs.append(w)
		w.initalize(x_pos,i)
		w.set_collision_width(dis_between_springs)
		w.connect("splash",Callable(self,"splash"))
	
	var total_length = dis_between_springs * (spring_num - 1)
	var rectangle = RectangleShape2D.new().duplicate()
	var rectangle_pos = Vector2((total_length/2),(bottom/2))
	var rectangle_size = Vector2(total_length,bottom)
	water_body_area.position = rectangle_pos
	rectangle.set_size(rectangle_size)
	collision_shape.set_shape(rectangle)
	#splash(2,5)
	
func _physics_process(_delta):
	
	for i in springs:
		i.water_update(spring_const,dampening)
	var left_deltas = []
	var right_deltas = []
	for i in range (springs.size()):
		left_deltas.append(0)
		right_deltas.append(0)
	pass
			
	for j in range(passes):
		
		for i in range(springs.size()):
			if i > 0:
				left_deltas[i] = spread * (springs[i].hight - springs[i-1].hight)
				springs[i-1].velocity += left_deltas[i]
			if i < springs.size() - 1:
				right_deltas[i] = spread * (springs[i].hight - springs[i+1].hight)
				springs[i+1].velocity += right_deltas[i]
	
	new_border()
	draw_water_body()

func draw_water_body():
	var curve = water_border.curve
	var points = Array(curve.get_baked_points())
	var water_polygon_points = points	
	var first_index = 0
	var last_index = water_polygon_points.size()-1
	#for i in range(water_polygon_points.size()):
		#water_polygon_points[i].x = position.x + water_polygon_points[i].x
	#for i in range(water_polygon_points.size()):
		#water_polygon_points[i].y = position.y + water_polygon_points[i].y 
		
	water_polygon_points.append(Vector2(water_polygon_points[last_index].x, bottom))
	water_polygon_points.append(Vector2(water_polygon_points[first_index].x, bottom))
	
	water_polygon_points = PackedVector2Array(water_polygon_points)
		
	water_polygon.set_polygon(water_polygon_points)

	pass
		
func new_border():
	
	var curve = Curve2D.new().duplicate()
	
	var surface_points = []
	for i in range(springs.size()):
		surface_points.append(springs[i].position)
	
	for i in range(surface_points.size()):
		curve.add_point(surface_points[i])
	
	water_border.curve = curve
	water_border.smooth(true)
	water_border.queue_redraw()
	
	pass

	
func splash(index, speed):
	if index >= 0 and index < springs.size():
		springs[index].velocity += speed
	pass
	
	


func _on_water_body_area_body_entered(body):
	body.in_water()
	
	#creates a instace of the particle system
	#var s = splash_particle.instantiate()
	
	#adds the particle to the scene
	#get_tree().current_scene.add_child(s)
	
	#sets the position of the particle to the same of the body
	#s.global_position = body.global_position
	
	pass # Replace with function body.


func _on_water_body_area_body_exited(body):
	body.leave_water()
	pass # Replace with function body.
