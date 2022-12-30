extends CharacterBody2D

# The target node that the character should lock onto and move towards
var target_node: CharacterBody2D

# The movement speed of the character
@export var move_speed = 10

# The maximum distance that the character can be from the target before it stops moving
@export var max_distance = 50

func _physics_process(delta: float) -> void:
	# Check if the target node is set and exists
	if is_instance_valid(target_node) and target_node and target_node.is_inside_tree():
		# Calculate the distance between the character and the target node
		var distance = position.distance_to(target_node.position)

		# If the distance is greater than the maximum distance, move towards the target node
		if distance < max_distance:
			# Calculate the direction vector towards the target node
			var direction = (target_node.position - position).normalized()
			# Calculate the velocity vector based on the direction and the move speed
			velocity = direction * move_speed

			# Rotate the character towards the target node
			rotation = direction.angle()
			
			# Move the character towards the target node
			var collision = move_and_collide(velocity * delta)
			if collision and not collision.get_collider().is_queued_for_deletion():
				queue_free();
		else:
			target_node = null
	else:
		# If the target node is not set or does not exist, stop moving
		move_and_slide()
		detect_target()
		
func detect_target():
	# Get the list of colliders in the area
	var ants = get_tree().get_nodes_in_group("ants")
	# Find the nearest node of the target type
	for ant in ants:
		if ant == self:
			continue
		# Calculate the distance to the node
		var distance = position.distance_to(ant.position)
		if distance < max_distance:
			# Update the detected node and distance
			target_node = ant
			break

