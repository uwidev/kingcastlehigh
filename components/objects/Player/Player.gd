extends KinematicBody2D

var sound1 = AudioStreamPlayer.new()
var speed = 0
var in_range = 0
var cool_down = 0
var motion = Vector2()
var snowballcount = 1;
export (PackedScene) var bullet
export (String) var nametag
onready var firepoint = get_node("firepoint")

<<<<<<< HEAD
var canInteract = false
var interactable = null
=======
func _ready():
	self.add_child(sound1)
	sound1.stream = load("res://catched.mp3")
	sound1.play()
>>>>>>> f6786b116eee7dc5a968a04465102fe1ccb3cc6b

func _physics_process(delta):
	in_range -= 1
	cool_down -= 1
	var bb;
	motion.x = 0
	motion.y = 0
	
	if Input.is_action_pressed("W"+nametag):
		motion.y += -200
	if Input.is_action_pressed("S"+nametag):
		motion.y += 200
	if Input.is_action_pressed("A"+nametag):
		motion.x += -200
	if Input.is_action_pressed("D"+nametag):
		motion.x += 200
		
	if Input.is_action_pressed("W"+nametag):
		rotation_degrees = 0
	if Input.is_action_pressed("S"+nametag):
		rotation_degrees = 180
	if Input.is_action_pressed("A"+nametag):
		rotation_degrees = 270
	if Input.is_action_pressed("D"+nametag):
		rotation_degrees = 90
	if Input.is_action_pressed("A"+nametag) and Input.is_action_pressed("W"+nametag):
		rotation_degrees = 315
	if Input.is_action_pressed("A"+nametag) and Input.is_action_pressed("S"+nametag):
		rotation_degrees = 225
	if Input.is_action_pressed("D"+nametag) and Input.is_action_pressed("W"+nametag):
		rotation_degrees = 45
	if Input.is_action_pressed("D"+nametag) and Input.is_action_pressed("S"+nametag):
		rotation_degrees = 135
		
	
	if (Input.is_action_just_pressed("catch"+nametag) and in_range > 0 and cool_down <= 0):
		in_range = 0
		snowballcount += 1
		sound1.play()
		pass
	
#	if Input.is_action_pressed("ui_up"):
#		speed = -200;
#	elif Input.is_action_pressed("ui_down"):
#		speed = 200;
#	else:
#		speed = 0;

#	if Input.is_action_pressed("ui_right"):
#		rotation += 0.1;
#	elif Input.is_action_pressed("ui_left"):
#		rotation += -0.1;
	
#	motion.x = speed * -sin(rotation);
#	motion.y = speed * cos(rotation);
	move_and_slide(motion);
	update()
	
	if Input.is_action_just_released("shoot"+nametag) and snowballcount > 0:
		snowballcount -= 1
		cool_down = 100
		bb = bullet.instance()
		firepoint.add_child(bb)
		bb.position = position
		bb.set_direction(get_global_mouse_position())
		bb._ready()
		
	
	# Interacting with object
	if Input.is_action_just_pressed("interact"+nametag):
		if canInteract:
			interactable.interact()
			print_debug('INTERACTED!')
	
func _draw():
	if Input.is_action_pressed("shoot"+nametag) and snowballcount > 0:
		draw_line(Vector2(0, 0), get_local_mouse_position(), Color(0,255,0), 10)

func _on_snowball_enter(area : Area2D):
	in_range = 100
	
	print_debug('SOMETHING ENTERED!')
	# If area detected on layer 5 (Generator Layer), allow interaction
	if area.get_collision_layer() == 5:
		print_debug('Player ' + nametag + ' can now interact w/ generator!')
		interactable = area
		canInteract = true

func _on_Area2D_exit(area : Area2D):
	# If area not detected on layer 5 (Generator layer), restrict interaction
	if area.get_collision_layer() == 5:
		print_debug('Player ' + nametag + ' can no longer interact w/ generator!')
		canInteract = false