extends CharacterBody2D

@export var move_speed = 10
@export var agro_distance = 50

var target_node: CharacterBody2D
var wander_position
var size
var screen_size
var width
var height

func _ready():
	size = $Sprite2D.get_rect().size
	width = size.x / 2
	height = size.y / 2
	screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	if has_valid_target():
		follow_target()
	else:
		wander()
	move(delta)
		
func follow_target():
	var direction = (target_node.position - position).normalized()
	velocity = direction * move_speed
	rotation = direction.angle()
	
func wander():
	if wander_position == null:
		detect_wander_position()
	var direction = (wander_position - position).normalized()
	velocity = direction * move_speed
	rotation = direction.angle()
	if (position.x - width < 0 or position.x + width > screen_size.x):
		wander_position = null
	elif (position.y < 0 - height or position.y + height > screen_size.y):
		wander_position = null
	elif get_distance_to_wander_position() < 0.2:
		wander_position = null
		
func move(delta: float):
	position.x = clamp(position.x, 0 + width, screen_size.x - width)
	position.y = clamp(position.y, 0 + height, screen_size.y - height)
	var collision = move_and_collide(velocity * delta)
	if collision and not collision.get_collider().is_queued_for_deletion():
		handle_collision()
	
func get_distance_to_target():
	var distance = position.distance_to(target_node.position)
	return distance
	
func get_distance_to_wander_position():
	var distance = position.distance_to(wander_position)
	return distance
		
func has_valid_target():
	if is_instance_valid(target_node) and target_node and target_node.is_inside_tree():
		return true
	else:
		detect_target()
		return false
		
func detect_target():
	var ants = get_tree().get_nodes_in_group("ants")
	for ant in ants:
		if ant == self:
			continue
		var distance = position.distance_to(ant.position)
		if distance < agro_distance:
			target_node = ant
			wander_position = null
			break
			
func detect_wander_position():
	var x = randi_range(width, screen_size.x - width)
	var y = randi_range(height, screen_size.y - height)
	wander_position = Vector2(x, y)
			
func handle_collision():
	queue_free()
