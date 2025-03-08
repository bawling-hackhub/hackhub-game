extends Control

signal resume_game
signal reset_game
signal quit_game

func _ready():
	hide()  # Hide the menu when the game starts
	# Make sure these paths match your actual node structure
	$Panel/Resume.connect("pressed", Callable(self, "_on_resume_pressed"))
	$Panel/Reset.connect("pressed", Callable(self, "_on_reset_pressed"))
	$Panel/Quit.connect("pressed", Callable(self, "_on_quit_pressed"))

func _on_resume_pressed():
	emit_signal("resume_game")

func _on_reset_pressed():
	emit_signal("reset_game")

func _on_quit_pressed():
	emit_signal("quit_game")
