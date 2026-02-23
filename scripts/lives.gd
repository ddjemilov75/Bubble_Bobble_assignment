extends Node2D

var hearts: Array = []
var life_count: int = 3
var score: int = 0

func _ready():
	hearts = [$Heart1, $Heart2, $Heart3]
	print("Hearts found: ", hearts)
	
func add_score():
	score += 1
	$ScoreLabel.text = "Score: " + str(score)
	
func lose_life():
	if hearts.size() > 0:
		hearts[-1].queue_free()
		hearts.pop_back()
		life_count -= 1
		if life_count <= 0:
			get_node("/root/Main/GameOver").show_gameover(score)
