extends Node2D

var curGame = 0
var totGames
@export var scenes: Array[PackedScene]
@export var gameContainer: Node
#var gameContainer

var scene
var puzzle_parts
var curScore = 0
var totScore
var zIndex = 1000
var xSlide = 1400


func _ready():
	totGames = len(scenes)
	#gameContainer = get_tree().get_root().get_node("GAME")
	loadGame()

func loadGame():
	curScore = 0
	scene = scenes[curGame].instantiate()
	add_child(scene)
	
	puzzle_parts = get_tree().get_nodes_in_group("puzzle_part")
	totScore = puzzle_parts.size()
	#print(totScore)
#
#	var tween = get_tree().create_tween()
#	scene.position.x = -xSlide
#	tween.tween_property(scene, "position:x", 0, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	
	var count = 0
	for part in puzzle_parts:
		var tween = get_tree().create_tween()
		part.position.x += -xSlide
		tween.tween_property(part, "position:x", part.position.x + xSlide, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT).set_delay( count * 0.05 )
		tween.tween_callback(part.activate)
		count += 1
	
	var tween = get_tree().create_tween()
	var contour = scene.get_node('Container').get_node('Contour')
	contour.scale = Vector2(0, 0)
	tween.tween_property(contour, "scale", Vector2(1, 1), 1.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).set_delay( 0.3 )




func addScore():
	print('addScore')
	curScore+=1
	if(curScore == totScore):
		#print(curGame)
		#print(totGames)
		endGamePart()

func endAllGames():
	print('endAllGames')
	#print(gameContainer)
	var tw1 = get_tree().create_tween()
	tw1.tween_property(gameContainer, "position:y", -300, 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	pass

func endGamePart():
	#do celebrate animation
	await get_tree().create_timer(0.75).timeout
	get_node("Win_Particles").emitting = true
	
	#hide other parts
#	for part in puzzle_parts:
#		part.active = false
#		part.visible = false
	#show only part 1
#	var part0 = puzzle_parts[0]
#	part0.visible = true
	#set texture as full size
#	var w = part0.texture.get_size().x
#	var h = part0.texture.get_size().y
#	part0.polygon[0] = Vector2(0,0)
#	part0.polygon[1] = Vector2(w,0)
#	part0.polygon[2] = Vector2(w,h)
#	part0.polygon[3] = Vector2(0,h)
	
	#hide contour
	var container = scene.get_node('Container')
	var contour = container.get_node('Contour')
	var mat = contour.material
	var tw1 = get_tree().create_tween()
	tw1.tween_property(mat, "shader_parameter/line_thickness", 0, 0.5)
	tw1.tween_property(container, "position:x", xSlide, 1).set_trans(Tween.TRANS_EXPO).set_ease (Tween.EASE_IN)
	
	
	await get_tree().create_timer(1.5).timeout
	scene.queue_free()
	await get_tree().create_timer(0.1).timeout
	
	print('haa - ', curGame, ' - ', totGames)
	if(curGame < totGames-1):
		curGame += 1
		loadGame()
	else:
		endAllGames()



func getZ():
	zIndex+=1
	return zIndex
