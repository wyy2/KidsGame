extends Node

func _on_button_puzzle_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/GAMES/Puzzles/01/Puzzle_01.tscn")
	
func _on_button_build_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/GAMES/Build/01/Build_01.tscn")

func _on_button_race_pressed() -> void:
	print("Race pressed!")

func _on_button_count_pressed() -> void:
	print("Race pressed!")
