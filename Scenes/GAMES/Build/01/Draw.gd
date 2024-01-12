extends Node2D

@export var vertices: PackedVector2Array
@export var color: Color

var is_dragging = false

func _ready():
	# Assuming 'vertices' is an export variable of type PackedVector2Array
	# Convert PackedVector2Array to regular Array for ease of use
	var piece_vertices = []
	for i in range(vertices.size()):
		piece_vertices.append(vertices[i])

	# Add a separate CollisionPolygon2D for each puzzle piece
	var collision_shape = CollisionPolygon2D.new()
	collision_shape.polygon = piece_vertices
	add_child(collision_shape)

func _draw():
	var rect_position_bottom
	# Convert PackedVector2Array to regular Array for ease of use
	var piece_vertices = []
	for i in range(vertices.size()):
		piece_vertices.append(vertices[i])

	# Calculate the center of the puzzle piece
	var center = Vector2(0, 0)
	for point in piece_vertices:
		center += point
	center /= piece_vertices.size()

	# Check if the bottom is flat
	var is_bottom_flat = is_flat_bottom(piece_vertices)

	var larger_points = []

	for point in piece_vertices:
		larger_points.append(point + Vector2(2, 2))

	# Draw the larger polygon
	draw_colored_polygon(larger_points, Color(0, 0, 0))

	# Draw the original polygon
	draw_colored_polygon(piece_vertices, Color(1, 1, 1))

	# Define the size of the rectangle
	var rect_size = Vector2(10, 10)  # Adjust the size as needed

	# Calculate the position of the top-left corner of the rectangle at the top
	var rect_position_top = center - Vector2(rect_size.x / 2, rect_size.y)
	draw_rect(Rect2(rect_position_top.x, rect_position_top.y, rect_size.x, rect_size.y), Color(0, 1, 0, 0.5))

	# Check if the bottom is not flat and draw the rectangle at the bottom
	if not is_bottom_flat:
		rect_position_bottom = center - Vector2(rect_size.x / 2, 0)
		draw_rect(Rect2(rect_position_bottom.x, rect_position_bottom.y, rect_size.x, rect_size.y), Color(0, 1, 0, 0.5))

	# Debug information
	draw_line(center - Vector2(5, 0), center + Vector2(5, 0), Color(1, 0, 0), 1)
	draw_line(center - Vector2(0, 5), center + Vector2(0, 5), Color(1, 0, 0), 1)

	var debug_text = "Bottom is flat"
	if not is_bottom_flat:
		debug_text = "Bottom is not flat"
	# If using this method in a script that redraws constantly, move the
	# `default_font` declaration to a member variable assigned in `_ready()`
	# so the Control is only created once.
	var default_font = ThemeDB.fallback_font
	var default_font_size = ThemeDB.fallback_font_size
	draw_string(default_font, center + Vector2(10, 10), debug_text, HORIZONTAL_ALIGNMENT_LEFT, -1, default_font_size)

	
	draw_rect(Rect2(center.x - 1, center.y - 1, 2, 2), Color(1, 0, 0))
	draw_rect(Rect2(rect_position_top.x, rect_position_top.y, rect_size.x, rect_size.y), Color(0, 1, 0, 0.5))
	if not is_bottom_flat:
		draw_rect(Rect2(rect_position_bottom.x, rect_position_bottom.y, rect_size.x, rect_size.y), Color(0, 1, 0, 0.5))

# Function to check if the bottom is flat
func is_flat_bottom(vertices):
	# Implement your logic to check if the bottom is flat
	# For example, check if the y-coordinates of the bottom vertices are approximately the same
	var epsilon = 0.01  # Adjust the epsilon value based on your precision requirements
	
	var bottom_y = vertices[0].y  # Assuming the first vertex is part of the bottom
	for i in range(1, vertices.size()):
		if abs(vertices[i].y - bottom_y) > epsilon:
			return false

	return true
	
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			# Check if the mouse click is within the bounding box of this node
			# TODO: Fix Rect2 size
			var rect = Rect2(position,Vector2(300,100))
			if rect.has_point(event.position):
				is_dragging = true
			else:
				is_dragging = false
		elif event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = false

	if is_dragging and event is InputEventMouseMotion:
		# Update the position of the dragged node
		set_position(get_position() + event.relative)
		

var collision_count = 0
var max_collisions = 5  # Set the maximum number of collisions to print

# Function to check if the top of this puzzle piece has entered the bottom of another piece
func is_top_entered(other_piece):
	#var this_top = global_position.y
	#var other_bottom = other_piece.global_position.y + other_piece.rect_size.y * other_piece.self_modulate.y
#
	## Check if the top of this piece has entered the bottom of the other piece
	#return this_top <= other_bottom
	pass

# Function to handle physics process
func _process(delta):
	var parent = get_parent()

	for other_piece in parent.get_children():
		if other_piece != self and other_piece is Sprite2D and is_top_entered(other_piece):
			print("Top of", name, "entered bottom of", other_piece.name)
			print("Global Position:", global_position)
			print("Other Global Position:", other_piece.global_position)
			print("\n")
