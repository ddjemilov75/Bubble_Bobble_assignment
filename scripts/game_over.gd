extends CanvasLayer

func _ready():
	hide()

func show_gameover(score: int):
	$ScoreLabel.text = "Score: " + str(score)
	show()
	get_tree().paused = true

func _input(_event):
	if get_tree().paused and Input.is_action_just_pressed("restart"):
		get_tree().paused = false
		get_tree().reload_current_scene()
