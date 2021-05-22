extends Node2D

var is_game_over = false
var asteroid = preload("res://asteroid.tscn")
const SCREEN_WIDTH = 320.0
const SCREEN_HEIGHT = 180.0
var score = 0

func _ready():
	randomize()
	get_node("player").connect("destroyed", self, "_on_player_destroyed")
	get_node("spawn_timer").connect("timeout", self, "_on_spawn_timer_timeout")

func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
	if is_game_over and Input.is_key_pressed(KEY_ENTER):
		get_tree().change_scene("res://stage.tscn")

func _on_player_destroyed():
	get_node("ui/retry").show()
	is_game_over = true

func _on_spawn_timer_timeout():
	var asteroid_instance = asteroid.instance()
	asteroid_instance.position = Vector2(SCREEN_WIDTH + 8, rand_range(0, SCREEN_HEIGHT))
	asteroid_instance.move_speed += score
	get_node("spawn_timer").wait_time *= 0.99
	asteroid_instance.connect("score", self, "_on_player_score")
	add_child(asteroid_instance)

func _on_player_score():
	score += 1
	get_node("ui/score").text = "Score : " + str(score) 
