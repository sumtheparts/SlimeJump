class_name player
extends CharacterBody2D

var mv : movement_values = null
@export var mv_res : movement_values
@export var mv_res_wat : movement_values
@export var mv_res_slime : movement_values

func _ready():
	mv = mv_res
	
var UP_DIRECTION :Vector2  = Vector2.UP

@onready var _pivot : Node2D = $Node2D
@onready var _animation_player : AnimatedSprite2D = $Node2D/AnimatedSprite2D
@onready var _start_scale : Vector2 = _pivot.scale

var ground_time := 0 

var slump_factor := 0.10
var _jumps_count := 0
var _velocity := Vector2.ZERO

var  idle_interupt : bool
var ground_time_pause : bool = false

signal  ground_timeout_true
signal  ground_timeout_false


func in_water():
	ground_time_pause = true
	mv = mv_res_wat
func leave_water():
	ground_time_pause = false
	mv = mv_res
	
func in_slime():
	slump_factor = 0.5
	mv = mv_res_slime
	pass
	
func leave_slime():
	slump_factor = 0.1
	mv = mv_res
	pass
	
func _physics_process(delta):
	
	var dir = Input.get_axis("left", "right")
	if dir != 0 and is_on_floor() and ground_time < 20:
		_velocity.x = lerp(velocity.x, dir * mv.speed , mv.acceleration)
	elif dir !=0 and ground_time >= 20 and is_on_floor():
		_velocity.x = lerp(velocity.x, (dir * mv.speed)*slump_factor, mv.acceleration)
	elif dir !=0 and not is_on_floor():
		_velocity.x = lerp(velocity.x, (dir * mv.speed), mv.acceleration)
	elif is_on_floor():
		_velocity.x = lerp(velocity.x, 0.0, mv.friction)

	var is_falling : bool =  not is_on_floor()	
	var is_jumping := Input.is_action_just_pressed("jump") and is_on_floor()
	var is_duble_jumping := Input.is_action_just_pressed("jump") and is_falling
	var is_jump_cancelled : bool = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var is_idling :bool = ground_time > 20
	var is_runing := is_on_floor() and not is_zero_approx(velocity.x) and ground_time < 20
	
	if is_on_floor() == true and ground_time_pause == false:
		ground_time += 1
	elif is_on_floor() == false:
		ground_time = 0
	if is_falling == true:
		_velocity.y += mv._gravity * delta
	if ground_time > 40 or ground_time_pause == true:
		ground_timeout_true.emit()
	else:
		ground_timeout_false.emit()
		
	if is_jumping:
		_jumps_count += 1
		_velocity.y = -mv.jump_speed
	elif is_duble_jumping:
		if _jumps_count < mv.max_jumps:
			_jumps_count += 1
			_velocity.y = -mv.dub_jump_speed
	elif is_jump_cancelled:
		_velocity.y = 0
	if is_on_floor():
		_jumps_count = 0
	if not is_zero_approx(_velocity.x):
		_pivot.scale.x = sign(_velocity.x) * _start_scale.x
		
		

#	place_slime()
		
	velocity = _velocity
	move_and_slide()
	
	if is_jumping or is_duble_jumping:
		_animation_player.play("jump")
		idle_interupt = false
	elif is_runing:
		_animation_player.play("run")
		idle_interupt = false
	elif is_falling:
		_animation_player.play("fall") 
		idle_interupt = false
	elif is_idling:
		is_idle()
		

	
func is_idle():
	if idle_interupt == false:
		_animation_player.play("idle")
		idle_interupt = true
	else:
		pass

