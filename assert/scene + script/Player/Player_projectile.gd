
extends Particles2D

# Authored by SuryaPrakash


export var speed := 600


onready var projectile_destroy_fx:=preload("res://scene + script/Hit and Hurt Box/projectile_destroy_fx.tscn")

var mat
var direction := 1
var velocity := Vector2.ZERO
var hit_fx


func _ready() -> void:
	
	emitting = true
	


func _physics_process(delta: float) -> void:

	velocity.x = direction*speed*delta

	translate(velocity)
	
	


func attack_dir (attack_dir):

	direction = attack_dir
	
	self.process_material.set_shader_param("angle",90*attack_dir)





func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()







func _on_HurtBox_body_entered(body: Node) -> void:
	hit_fx=projectile_destroy_fx.instance()
	queue_free()
	get_parent().add_child(hit_fx)
	hit_fx.global_position=global_position
	hit_fx.play("animate")


func _on_HurtBox_area_entered(area: Area2D) -> void:
	hit_fx=projectile_destroy_fx.instance()
	queue_free()
	get_parent().add_child(hit_fx)
	hit_fx.global_position=global_position
	hit_fx.play("animate")

# -By Suryaprakash S
