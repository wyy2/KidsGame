@tool
extends Sprite2D

func _ready():
	setMiddlePos()


func _physics_process(delta):
	if Engine.is_editor_hint():
		setMiddlePos()


func setMiddlePos():
	var w = texture.get_size().x
	var h = texture.get_size().y
	position = Vector2(w/2, h/2)
