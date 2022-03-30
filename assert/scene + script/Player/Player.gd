extends "res://scene + script/Player/player_stats.gd"
# Authored by SuryaPrakash

#onready var's:-
#-------------



onready var projectile:=preload("res://scene + script/Player/Player_projectile.tscn")

onready var gun_cooldown:=$Timer
onready var plasma_weapon:=$Player_Wepon
onready var right_position:=$RightPosition
onready var left_position:=$LeftPosition
onready var animation_player:=$AnimationPlayer
onready var backshell:=$back_shell
onready var frontshell:=$front_shell


#-------------------------------------------------------------------------------

#export var's:-
#------------

export var max_speed:=850.0
export var friction:=750.0
export var accleration:=750.0
export var jump_height:=100000.0

#-------------------------------------------------------------------------------

#enum's:-
#------

enum {
	MOVEMENT,
	ATTACK,
	DEAD
}

#-------------------------------------------------------------------------------

#constant's:-
#----------


const FLOOR_DETECT_LENGTH := 20


#-------------------------------------------------------------------------------

#variable's:-
#----------



var rotation_deg:=0.05
var actual_position:=Vector2.ZERO
var translate_speed:=500

var temp_vector := 1
var input_vector:=Vector2.ZERO
var input_vector_x:=Vector2.ZERO
var input_vector_y:=Vector2.ZERO

var stats:=PlayerStats
var state:=MOVEMENT
var can_shoot := true
var is_jump_intrupted
var snap_vector

#-------------------------------------------------------------------------------


func _ready() -> void:
	
	stats.connect("no_health",self,"dead")

#-------------------------------------------------------------------------------


func _physics_process(delta: float) -> void:
	
	
	input_vector=get_input_direction()
	
	
	match state:
		
		
		MOVEMENT:
			
			movement_state(input_vector,delta)
			
		
		
		ATTACK:
			attack_state(temp_vector)
		
		
		DEAD:
			queue_free()
	
	



#-------------------------------------------------------------------------------


func movement_state(input_vector,delta):
	
	
	snap_vector = Vector2.DOWN * FLOOR_DETECT_LENGTH if input_vector.y == 0.0 else Vector2.ZERO
	
	is_jump_intrupted = Input.is_action_just_released("up") and velocity.y < 0
	
	
	
	if input_vector.x:
		velocity.x = velocity.move_toward(input_vector*max_speed,accleration*delta).x
		
		if velocity.x > 0:
			temp_vector=1
			animation_player.play("right")
			rotate(rotation_deg)
		elif velocity.x < 0:
			temp_vector=-1
			animation_player.play("left")
			rotate(-rotation_deg)
	else:
		velocity.x=velocity.move_toward(Vector2.ZERO,friction*delta).x
		animation_player.stop()
		rotate(0)
	
	
	if input_vector.y:
		velocity.y = input_vector.y*jump_height*delta
		
		
	
	if is_jump_intrupted:
		velocity.y = 0.0
	
	
	if temp_vector == 1 :
		
		if plasma_weapon.global_position.x < right_position.global_position.x :
			
			weapon_translate(delta)
		
	elif temp_vector == -1 :
		
		if plasma_weapon.global_position.x > left_position.global_position.x :
			
			weapon_translate(delta)
		
	
	
	move()
	
	if Input.is_action_just_pressed("attack") and can_shoot :
		state=ATTACK
		
	
	


func attack_state(attack_dir):
	
	
	
	
	var bullet=projectile.instance()
	get_parent().add_child(bullet)
	bullet.global_position = plasma_weapon.global_position
	bullet.attack_dir(temp_vector)
	
	
	can_shoot = false
	gun_cooldown.start(1)
	
	
	state = MOVEMENT


func dead():
	
	state = DEAD
	


#-------------------------------------------------------------------------------

func get_input_direction():
	
	return Vector2((Input.get_action_strength("right")-Input.get_action_strength("left")),
				(-Input.get_action_strength("up") if is_on_floor() and Input.is_action_just_pressed("up") else 0.0))
	



func rotate(deg):
	backshell.rotation+=deg
	backshell.rotation=clamp(deg,-0.3,0.3)
	frontshell.rotation+=deg
	frontshell.rotation=clamp(deg,-0.3,0.3)

func weapon_translate(delta):
	actual_position.x = temp_vector*translate_speed*delta
	plasma_weapon.translate(actual_position)

func move():
	velocity = move_and_slide_with_snap(
		velocity, snap_vector, FLOOR, true, 4, 0.9, false
	)
	


#-------------------------------------------------------------------------------





func _on_Timer_timeout() -> void:
	can_shoot = true


func _on_HurtBox_area_entered(area: Area2D) -> void:
	
	stats.health -= area.damage
	

# -By SuryaPrakash S
