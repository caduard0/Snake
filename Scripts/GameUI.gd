extends Control

var snake
onready var score = get_node("Score")

func _ready():
	if get_parent():
		snake = get_parent().get_node("Snake")

func _process(delta):
	if snake != null:
		score.text = "Score: " + String(snake.size - 2)
