extends Control


var edge_length = 100

var cube = F.Cube.new()
var tetrahedron = F.Tetrahedron.new()
var octahedron = F.Octahedron.new()
var icosahedron = F.Icosahedron.new()
#var dodecahedron = F.Dodecahedron.new()
var axis = F.Axis.new()
var spatial = cube

var frame_count = 0

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

var world_center: Vector3 = Vector3(200, 0, 0)

func _ready() -> void:
	cube.translate(world_center.x, world_center.y, world_center.z)
	tetrahedron.translate(world_center.x, world_center.y, world_center.z)
	octahedron.translate(world_center.x * 3 / 4,  world_center.y * 3 / 4, world_center.z * 3 / 4)
	icosahedron.translate(100, 0, 0)
	for point in icosahedron.points:
		print(point)
		
	#dodecahedron.translate(200, 0, 0)
	Engine.max_fps = 20


func _process(_delta: float) -> void:
	return
	#if (frame_count > 100):
	#	return
	#frame_count += 1
	var vec = spatial.get_middle()
	vec.translate(world_center.x, world_center.y, world_center.z)
	spatial.rotation_about_center(vec, 1, 1, 1)
	
	queue_redraw()

func draw_object(obj: F.Spatial):
	for edge in obj.edges:
		var p1: F.Point = obj.points[edge.x].duplicate()
		var p2: F.Point = obj.points[edge.y].duplicate()
		
		var axonometric_matrix = F.AffineMatrices.get_axonometric_matrix(35.26, 45)
		
		p1.apply_matrix(axonometric_matrix)
		p2.apply_matrix(axonometric_matrix)
		
		draw_line(p1.get_vec2d(), p2.get_vec2d(), Color.RED, 0.5, true)


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
	draw_object(spatial)
	draw_line(p1_line.get_vec2d(), p2_line.get_vec2d(), Color.BLUE)
	#draw_axis(axis)


func _on_apply_pressed() -> void:
	spatial.rotation_about_y(float(rotate_oy.text))
	spatial.rotation_about_z(float(rotate_oz.text))
	spatial.rotate_about_center(float(rotate_ox.text))
	spatial.scale_(float(scale_mx.text), float(scale_my.text), float(scale_mz.text))
	
	queue_redraw()


func _on_clear_pressed() -> void:
	get_tree().reload_current_scene()


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0: spatial = cube
		1: spatial = tetrahedron
		2: spatial = octahedron
		3: spatial = icosahedron
		#4: spatial = dodecahedron
	queue_redraw()


func _on_mirror_ox_pressed() -> void:
	pass


func _on_mirror_oy_pressed() -> void:
	pass # Replace with function body.


func _on_mirror_oz_pressed() -> void:
	pass # Replace with function body.


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


func _on_apply_scale_center_pressed() -> void:
	var vec3 = read_scale()
	var mx: float = vec3.x
	var my: float = vec3.y
	var mz: float = vec3.z
	var vec = spatial.get_middle()
	vec.translate(world_center.x, world_center.y, world_center.z)
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
