extends Control


var edge_length = 100

var cube = F.Cube.new()
var tetrahedron = F.Tetrahedron.new()
var octahedron = F.Octahedron.new()
var icosahedron = F.Icosahedron.new()
var dodecahedron = F.Dodecahedron.new()
var axis = F.Axis.new()
var spatial = cube

var axonometric_matrix = F.AffineMatrices.get_axonometric_matrix(35.26, 45)
var perspective_matrix = F.AffineMatrices.get_perspective_matrix(-300)
var projection_matrix = axonometric_matrix

var is_auto_rotating = true

var frame_count = 0

var hue_shift = 0.0
var color_speed = 0.1


## Translation values
@onready var translate_dx: LineEdit = $HBox/MarginContainer/Menu/Translate/dx
@onready var translate_dy: LineEdit = $HBox/MarginContainer/Menu/Translate/dy
@onready var translate_dz: LineEdit = $HBox/MarginContainer/Menu/Translate/dz

## Rotation values (don't forget deg_to_rad)
@onready var rotate_ox: LineEdit = $HBox/MarginContainer/Menu/Rotate/ox
@onready var rotate_oy: LineEdit = $HBox/MarginContainer/Menu/Rotate/oy
@onready var rotate_oz: LineEdit = $HBox/MarginContainer/Menu/Rotate/oz

## Rotation Line values
@onready var rotate_line_x_1: LineEdit = $HBox/MarginContainer/Menu/RotateLine/x1
@onready var rotate_line_y_1: LineEdit = $HBox/MarginContainer/Menu/RotateLine/y1
@onready var rotate_line_z_1: LineEdit = $HBox/MarginContainer/Menu/RotateLine/z1
@onready var rotate_line_x_2: LineEdit = $HBox/MarginContainer/Menu/RotateLine/x2
@onready var rotate_line_y_2: LineEdit = $HBox/MarginContainer/Menu/RotateLine/y2
@onready var rotate_line_z_2: LineEdit = $HBox/MarginContainer/Menu/RotateLine/z2
@onready var deg: LineEdit = $HBox/MarginContainer/Menu/RotateLine/deg

## Scale values
@onready var scale_mx: LineEdit = $HBox/MarginContainer/Menu/Scale/mx
@onready var scale_my: LineEdit = $HBox/MarginContainer/Menu/Scale/my
@onready var scale_mz: LineEdit = $HBox/MarginContainer/Menu/Scale/mz

@onready var world_center: Vector3 = Vector3(450, 300, 200)

func _ready() -> void:
	cube.translate(world_center.x, world_center.y, world_center.z)
	tetrahedron.translate(world_center.x, world_center.y, world_center.z)
	octahedron.translate(world_center.x, world_center.y, world_center.z)
	icosahedron.translate(world_center.x, world_center.y, world_center.z)
	dodecahedron.translate(world_center.x, world_center.y, world_center.z)
	#icosahedron.translate(100, 0, 0)
	#for point in icosahedron.points:
	#	print(point)
		
	#dodecahedron.translate(200, 0, 0)
	Engine.max_fps = 20


func _process(delta: float) -> void:
	if not is_auto_rotating:
		return
	
	hue_shift += color_speed * delta
	hue_shift = fmod(hue_shift, 1.0)
	
	var vec = spatial.get_middle()
	spatial.rotation_about_center(vec, 1, 1, 1)
	
	queue_redraw()

func draw_object(obj: F.Spatial):
	for edge in obj.edges:
		var p1: F.Point = obj.points[edge.x].duplicate()
		var p2: F.Point = obj.points[edge.y].duplicate()
		
		p1.apply_matrix(projection_matrix)
		p2.apply_matrix(projection_matrix)
		
		draw_line(p1.get_vec2d(), p2.get_vec2d(), Color.RED, 0.5, true)

func draw_by_faces(obj: F.Spatial):
	for face in obj.faces:
		var old_point = obj.points[face[0]].duplicate()
		old_point.apply_matrix(projection_matrix)
		
		var face_color = get_edge_color()
		
		for index in face.slice(1, face.size()):
			var p = obj.points[index].duplicate()
			p.apply_matrix(projection_matrix)
			draw_line(old_point.get_vec2d(), p.get_vec2d(), face_color, 0.5, true)
			old_point = p
		var first_point = obj.points[face[0]].duplicate()
		first_point.apply_matrix(projection_matrix)
		draw_line(first_point.get_vec2d(), old_point.get_vec2d(), face_color, 0.5, true)

func get_edge_color() -> Color:
	var dynamic_color = Color.from_hsv(hue_shift, 0.8, 0.9)
	
	return dynamic_color


func draw_axis(axis: F.Axis):
	var isometric_matrix = F.AffineMatrices.get_axonometric_matrix(35.26, 45)
	for edge in axis.edges:
		var p1 = axis.points[edge.x].duplicate()
		var p2 = axis.points[edge.y].duplicate()
		
		p1.apply_matrix(isometric_matrix)
		p2.apply_matrix(isometric_matrix)
		
		draw_line(p1.get_vec2d(), p2.get_vec2d(), Color.GREEN, 0.5, true)

var p1_line: F.Point = F.Point.new(0, 0, 0)
var p2_line: F.Point = F.Point.new(0, 0, 0)

func _draw():
	draw_by_faces(spatial)
	draw_line(p1_line.get_vec2d(), p2_line.get_vec2d(), Color.BLUE)
	#draw_axis(axis)

func _on_clear_pressed() -> void:
	get_tree().reload_current_scene()


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0: spatial = cube
		1: spatial = tetrahedron
		2: spatial = octahedron
		3: spatial = icosahedron
		4: spatial = dodecahedron
	queue_redraw()


func _on_mirror_ox_pressed() -> void:
	spatial.miror(1, 1, -1)
	queue_redraw()


func _on_mirror_oy_pressed() -> void:
	spatial.miror(1, -1, 1)
	queue_redraw()


func _on_mirror_oz_pressed() -> void:
	spatial.miror(-1, 1, 1)
	queue_redraw()


func _on_apply_trans_pressed() -> void:
	spatial.translate(float(translate_dx.text), float(translate_dy.text), float(translate_dz.text))
	queue_redraw()


func _on_apply_rot_pressed() -> void:
	spatial.rotation_about_x(float(rotate_ox.text))
	spatial.rotation_about_y(float(rotate_oy.text))
	spatial.rotation_about_z(float(rotate_oz.text))
	queue_redraw()

func _on_apply_rot_center_pressed() -> void:
	var vec = spatial.get_middle()
	vec.translate(world_center.x, world_center.y, world_center.z)
	spatial.rotation_about_center(vec, float(rotate_ox.text), float(rotate_oy.text), float(rotate_oz.text))
	queue_redraw()


func read_scale() -> Vector3:
	var mx: float = 0
	var my: float = 0
	var mz: float = 0
	if scale_mx.text == "":
		mx = 1
	else:
		mx = float(scale_mx.text)
	if scale_my.text == "":
		my = 1
	else:
		my = float(scale_my.text)
	if scale_mz.text == "":
		mz = 1
	else:
		mz = float(scale_mz.text)
	return Vector3(mx, my, mz)

func _on_apply_scale_pressed() -> void:
	var vec3 = read_scale()
	var mx: float = vec3.x
	var my: float = vec3.y
	var mz: float = vec3.z
	
	spatial.scale_(mx, my, mz)
	queue_redraw()


func _on_apply_scale_center_pressed() -> void:
	var vec3 = read_scale()
	var mx: float = vec3.x
	var my: float = vec3.y
	var mz: float = vec3.z
	var vec = spatial.get_middle()
	spatial.scale_about_center(vec, mx, my, mz)
	queue_redraw()


func _on_apply_rotate_line_pressed() -> void:
	var x1 = float(rotate_line_x_1.text)
	var y1 = float(rotate_line_y_1.text)
	var z1 = float(rotate_line_z_1.text)
	var x2 = float(rotate_line_x_2.text)
	var y2 = float(rotate_line_y_2.text)
	var z2 = float(rotate_line_z_2.text)
	
	p1_line = F.Point.new(x1, y1, z1)
	p2_line= F.Point.new(x2, y2, z2)
	
	var matrix = F.AffineMatrices.get_axonometric_matrix(35.26, 45)
	p1_line.apply_matrix(matrix)
	p2_line.apply_matrix(matrix)
	
	var line: Vector3 = Vector3(x2-x1, y2-y1, z2-z1)
	var p: F.Point = F.Point.new(x1, y1, z1)
	p.translate(world_center.x, world_center.y, world_center.z)
	spatial.rotation_about_line(p, line, float(deg.text))
	queue_redraw()


func _on_option_button_2_item_selected(index: int) -> void:
	match index:
		0: projection_matrix = axonometric_matrix
		1: projection_matrix = perspective_matrix
	
	queue_redraw()


func _on_check_box_toggled(toggled_on: bool) -> void:
	is_auto_rotating = toggled_on
