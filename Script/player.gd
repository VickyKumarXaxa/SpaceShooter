extends Area2D
const MOVE_SPEED = 150.0
const SCREEN_WIDTH = 320
const SCREEN_HEIGHT = 180
var shot_scene = preload("res://shot.tscn")
var explosion_scene = preload("res://explosion.tscn")
var can_shoot = true
signal destroyed

func _process(delta):
	var input_dir = Vector2()
	if Input.is_key_pressed(KEY_UP):
		input_dir.y -= 1.0
	if Input.is_key_pressed(KEY_DOWN):
		input_dir.y += 1.0
	if Input.is_key_pressed(KEY_LEFT):
		input_dir.x -= 1.0
	if Input.is_key_pressed(KEY_RIGHT):
		input_dir.x += 1.0
	
	if Input.is_key_pressed(KEY_SPACE) and can_shoot:
		var stage_node = get_parent()
		var shot_instance = shot_scene.instance()
		shot_instance.position = position
		stage_node.add_child(shot_instance)
		can_shoot = false
		get_node("reload_timer").start()
	
	position += (delta*MOVE_SPEED)*input_dir
	if position.x < 0.0 + 8:
		position.x = 0.0 + 8
	elif position.x > SCREEN_WIDTH - 8:
		position.x = SCREEN_WIDTH - 8
	if position.y < 0.0 + 8:
		position.y = 0.0 + 8
	elif position.y > SCREEN_HEIGHT - 8:
		position.y = SCREEN_HEIGHT - 8

func _on_reload_timer_timeout():
	can_shoot = true


func _on_player_area_entered(area):
	if area.is_in_group("asteroid"):
		queue_free()
		
		var stage_node = get_parent()
		var explosion_instance = explosion_scene.instance()
		explosion_instance.position = position
		stage_node.add_child(explosion_instance)
		
		emit_signal("destroyed")
