extends CharacterBody2D

# The target node that the character should lock onto and move towards
var target_node: CharacterBody2D

# The movement speed of the character
@export var move_speed = 10

# The maximum distance that the character can be from the target before it stops moving
@export var max_distance = 1

# The distance to the detected node
var detected_distance = -1

func _physics_process(delta: float) -> void:
	
	detect_target()
	# Check if the target node is set and exists
	if target_node and target_node.is_inside_tree():
		# Calculate the distance between the character and the target node
		var distance = position.distance_to(target_node.position)

		# If the distance is greater than the maximum distance, move towards the target node
		if distance > max_distance:
			# Calculate the direction vector towards the target node
			var direction = (target_node.position - position).normalized()
			# Calculate the velocity vector based on the direction and the move speed
			velocity = direction * move_speed

			# Rotate the character towards the target node
			rotation = direction.angle()
			
			# Move the character towards the target node
			var collision = move_and_collide(velocity * delta)
			if collision:
				queue_free();
	else:
		# If the target node is not set or does not exist, stop moving
		velocity = Vector2.ZERO
		move_and_slide()
		
func detect_target():
	# Get the list of colliders in the area
	var ants = get_tree().get_nodes_in_group("ants")
	detected_distance = -1
	# Find the nearest node of the target type
	for ant in ants:
		if ant == self:
			continue
		# Calculate the distance to the node
		var distance = position.distance_to(ant.position)
		if detected_distance == -1 || distance > detected_distance:
			# Update the detected node and distance
			target_node = ant
			detected_distance = distance
#	if detected_distance > max_distance:
#		# Reset the detected node and distance if it is too far away
#		target_node = null
#		detected_distance = -1

