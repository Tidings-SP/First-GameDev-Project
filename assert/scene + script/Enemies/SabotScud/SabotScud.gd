extends KinematicBody2D

# Authored by SuryaPrakash

export var rotation_speed := 40
export var target_path := NodePath()


onready var flash := preload("res://scene + script/Enemies/SabotScud/muzzle_flash.tscn")
onready var missile := preload("res://scene + script/Enemies/SabotScud/Missile(sabotscud).tscn")
onready var target := get_node(target_path)
onready var timer := $Timer
onready var stats := $stats
onready var shootposition := $BarrelPivot/shootpoint
onready var barrelpivot := $BarrelPivot



var target_direction : Vector2
var target_vector : Vector2
var can_attack := false


func _ready() -> void:
	
	stats.connect("no_health",self,"dead")
	set_physics_process(false)
	



func _physics_process(delta: float) -> void:
	
	if  not is_on_floor() :
		move_and_collide(Vector2.DOWN*10)
	
	if barrelpivot.rotation_degrees >= 55 or barrelpivot.rotation_degrees <= -55 :
		rotation_speed *= -1
		
	
	barrelpivot.rotation_degrees += 1*rotation_speed*delta
	
	if PlayerStats.alive :
		target_direction = global_position.direction_to(target.global_position)
	target_vector = Vector2(sign(target_direction.x),sign(target_direction.y))
	
	if target_vector == Vector2(1,-1) and sign(barrelpivot.rotation_degrees) == 1 :
		
		can_attack = true
		
	elif target_vector == Vector2(-1,-1) and sign(barrelpivot.rotation_degrees) == -1 :
		
		can_attack = true
		
	else :
		
		can_attack = false
		
	
	



func _on_Timer_timeout() -> void:
	
	if PlayerStats.alive :
		if can_attack :
		
			var flash_fx := flash.instance()
			get_parent().add_child(flash_fx)
			flash_fx.global_position = shootposition.global_position
		
		
			var homing_missile := missile.instance()
			homing_missile.get_target_node(target)
			get_parent().add_child(homing_missile)
			homing_missile.rotation_degrees = -90.0
			homing_missile.global_position = shootposition.global_position



func dead():
	var blast_fx := flash.instance()
	queue_free()
	get_parent().add_child(blast_fx)
	blast_fx.scale = Vector2(2,2) 
	blast_fx.global_position = global_position
	blast_fx.offset = Vector2(0,-30)



func _on_HurtBox_area_entered(area: Area2D) -> void:
	
	stats.health -= area.damage
	




func _on_VisibilityNotifier2D_screen_entered() -> void:
	set_physics_process(true)
	timer.paused = false


func _on_VisibilityNotifier2D_screen_exited() -> void:
	set_physics_process(false)
	timer.paused = true
	


# -By Suryaprakash S
