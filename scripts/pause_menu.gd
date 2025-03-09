extends Control

func resume():
	get_tree().paused = false
	$".".set_visible(false);
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func pause():
	get_tree().paused = true
	$".".set_visible(true);
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ESC") and !$"../../Player".is_dead():
		if !get_tree().paused:
			pause()
		else:
			resume()

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Autoscript.score = 0
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()
