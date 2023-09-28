extends CharacterBody2D
class_name Ant

@export var move_speed = 10
@export var agro_distance = 50

var target_node: CharacterBody2D
var hp : int = 1

func _ready():
	hide()
	
func spawn(pos):
	position = pos
	show()
					
func add_hp(amount: int):
	hp += amount
	if hp <= 0:
		die()
	scale += Vector2(amount * .1, amount * .1)
	
func die():
	queue_free()
