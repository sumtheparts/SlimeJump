extends Node2D

#script for movemnt and interaction of each water spring

#velocity of i spring
var velocity = 0
#force on i spring
var force = 0
#displacemnt of i spring
var hight = 0
#Rest point of i spring
var targ_hight = 0

#Import spring collision body
@onready var collision = $Area2D/CollisionShape2D


var index = 0
#Ratio of movement for spring from collideing body
var motion_factor = 0.005
#Water partical on collision trigger
signal splash
#To pevent multiuple collisions per second 
var _cooldown : bool = false

#Update Spring velocity using displacement and force
func water_update(spring_const,dampening):
	hight = position.y
	var displacemnt = hight - targ_hight
	var loss = -dampening * velocity
	force = -spring_const * displacemnt + loss
	velocity += force
	position.y += velocity
	pass 

#Placemnt function for each spring
func initalize(x_pos,id):
	hight = position.y
	targ_hight = position.y
	velocity = 0
	position.x = x_pos
	index = id
	
#Sets collision shape for the water springs
func set_collision_width(value):
	var extents = collision.get_shape().size
	var new_extents = Vector2(value,extents.y)
	collision.shape.set_size(new_extents)
	pass

#interaction on body interacting with collision shape
func _on_area_2d_body_entered(body):
	
	if _cooldown == true:
		return
	if _cooldown == false:
		var speed = body._velocity.y * motion_factor
		emit_signal("splash",index,speed)
		_cooldown = true
		await get_tree().create_timer(1).timeout
		_cooldown = false
		#emit_signal("splash",index,speed)
	pass # Replace with function body.



	

