@tool
extends Polygon2D

@export var snap_dist: int
@export_range(-800, 800, 0.2) var x: int
@export_range(-800, 800, 0.2) var y: int

var wigg_amm = 2
var wigg_speed = 3
var wigg_time = randf()*0.5
var wigg_cur = 0

var active = false
var selected = false
var end = false
var pos0 = Vector2(0, 0)
var click_pos = Vector2(0, 0)
var placed_pos = Vector2(0, 0)
var center
var mat
var MAIN

func _ready():
	pos0 = position
	mat = material
	material = material.duplicate()
	MAIN = get_tree().root.get_child(0)

func activate():
	active = true

func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click") and not end:
		# MOUSE CLICK
		selected = true
		z_index = MAIN.getZ()
		click_pos = get_global_mouse_position() - pos0
		material.set_shader_parameter("line_color", Color(1, 1, 1, 1))

		
func _physics_process(delta):
	if(active):
		if not Engine.is_editor_hint():
			if selected:
				# MOUSE ON HOLD
				var cur_pos = get_global_mouse_position()
				position = cur_pos - click_pos
				
				var dist = position.distance_to( Vector2(0, 0) )
				if(dist < snap_dist):
					end = true
					selected = false
					MAIN.addScore()
			elif end:
				# ON DRAG SNAPPED
				position = position * 0.9
			else:
				# NO MOUSE EVENT
				wigg_time += delta
				wigg_cur = wigg_amm * sin(wigg_time * wigg_speed)
				var red_pos = (position - pos0) * 0.9 + pos0
				position = red_pos + Vector2(0, wigg_cur)
				
		
	if Engine.is_editor_hint():
		print(x, y)
		position = Vector2(x, y)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			# MOUSE RELEASE
			selected = false
			material.set_shader_parameter("line_color", Color(1, 1, 1, 0))
