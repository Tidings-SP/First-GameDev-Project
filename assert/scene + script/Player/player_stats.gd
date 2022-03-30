extends KinematicBody2D

# Authored by SuryaPrakash

class_name player_stats


onready var gravity=ProjectSettings.get("physics/2d/default_gravity")


const FLOOR:=Vector2.UP


var velocity:=Vector2.ZERO



func _physics_process(delta: float) -> void:
	
	velocity.y += gravity*delta if is_on_floor() else gravity*50*delta
	


# -By Suryaprkash S
