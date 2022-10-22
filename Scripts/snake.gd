extends TileMap

var arena_size = [31, 17]

var size = 2
var current_pos = Vector2(16, 9)

var food_pos = Vector2()

var snake = []

var direction = Vector2(0, -1)

var already_moved = false

func _ready():
	AddToSnake(current_pos)
	SpawnFood()

func _process(delta):
	Move()

func Move():
	if already_moved:
		return

	if direction.abs() == Vector2(1, 0):
		if Input.is_action_just_pressed("ui_down"):
			direction = Vector2(0, 1)
			already_moved = true
		if Input.is_action_just_pressed("ui_up"):
			direction = Vector2(0, -1)
			already_moved = true

	if direction.abs() == Vector2(0, 1):
		if Input.is_action_just_pressed("ui_right"):
			direction = Vector2(1, 0)
			already_moved = true
		if Input.is_action_just_pressed("ui_left"):
			direction = Vector2(-1, 0)
			already_moved = true

func Walk(_direction : Vector2):
	current_pos += _direction
	AddToSnake(current_pos)
	already_moved = false

func AddToSnake(_pos : Vector2):
	var _del = Vector2(-1, -1)
	snake.push_front(_pos)
	if snake.size() > size:
		_del = snake.pop_back()
	DrawSnake(_del)

func DetectFoodEaten():
	for _pos in snake:
		if _pos == food_pos:
			size += 1
			SpawnFood()
			return true

func SpawnFood():
	food_pos = Vector2(randi() % 32, randi() % 18)
	DrawTileMap(food_pos, 1)

func DrawSnake(_delete):
	for _pos in snake:
		self.set_cellv(_pos, 0)
	self.set_cellv(_delete, -1)

func DrawTileMap(_tile_pos : Vector2, _tile=0):
	self.set_cellv(_tile_pos, _tile)

func GetMatrix(_glob_pos : Vector2):
	return (_glob_pos / 32).abs()

func GetGlobalPosition(_matrix_pos : Vector2):
	return _matrix_pos * 32

func _on_WalkTimer_timeout():
	Walk(direction)
	DetectFoodEaten()
