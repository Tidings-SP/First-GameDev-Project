extends KinematicBody2D

# Authored by SuryaPrakash

onready var destroy := preload("res://scene + script/Enemies/SabotScud/missile_destroy.tscn")
onready var particle := $Particles2D


export var follow_speed := 19000.0



var target 
var target_position : Vector2
var follow_position : Vector2
var velocity : Vector2


func _ready() -> void:
	particle.emitting = true
	
	


func _physics_process(delta: float) -> void:
	
	if not PlayerStats.alive:
		queue_free()
		
	
	target_position = target.global_position
	
	follow_position = global_position.direction_to(target_position)
	
	
	velocity = follow_position * follow_speed * delta
	
	velocity = move_and_slide(velocity)
	
	rotation = follow_position.angle()
	

func get_target_node(target_node):
	
	target = target_node
	

func _on_HurtBox_body_entered(body: Node) -> void:
	
	queue_free()
	var destroy_fx = destroy.instance()
	get_parent().add_child(destroy_fx)
	destroy_fx.global_position = global_position
	destroy_fx.play("animate")
	


func _on_HurtBox_area_entered(area: Area2D) -> void:
	
	queue_free()
	var destroy_fx = destroy.instance()
	get_parent().add_child(destroy_fx)
	destroy_fx.global_position = global_position
	destroy_fx.play("animate")

# Authored by SuryaPrakash
