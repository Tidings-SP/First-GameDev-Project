extends Node

# Authored by SuryaPrakash


signal no_health
signal max_health_changed(value)
signal health_changed(value)


func _ready() -> void:
	
	self.health = max_health


export var max_health :=1 setget set_max_health


var health := max_health setget set_health
var alive := true


func set_max_health(value):
	max_health = value
	self.health = max_health
	emit_signal("max_health_changed",max_health)


func set_health(value):
	health = value
	emit_signal("health_changed",health)
	
	if health <=0 :
		emit_signal("no_health")
		alive = false
	


# -By SuryaPrakash S
