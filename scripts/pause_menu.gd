extends CanvasLayer

func _ready():
	hide()

func _input(_event):
	if get_tree().paused and visible:
		if Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("ui_accept"):
			resume()
		if Input.is_action_just_pressed("restart"):
			get_tree().paused = false
			get_tree().reload_current_scene()

func show_pause():
	show()
	get_tree().paused = true

func resume():
	hide()
	get_tree().paused = false
