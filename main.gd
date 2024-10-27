extends Control


var edge_length = 100
var cube = F.Cube.new()
var tetrahedron = F.Tetrahedron.new()
var axis = F.Axis.new()
var frame_count = 0

## Translation values
@onready var dx: LineEdit = $HBox/MarginContainer/Menu/Translate/dx
@onready var dy: LineEdit = $HBox/MarginContainer/Menu/Translate/dy
@onready var dz: LineEdit = $HBox/MarginContainer/Menu/Translate/dz

## Rotation values (don't forget deg_to_rad)
@onready var ox: LineEdit = $HBox/MarginContainer/Menu/Rotate/ox
@onready var oy: LineEdit = $HBox/MarginContainer/Menu/Rotate/oy
@onready var oz: LineEdit = $HBox/MarginContainer/Menu/Rotate/oz

## Scale values
@onready var mx: LineEdit = $HBox/MarginContainer/Menu/Scale/mx
@onready var my: LineEdit = $HBox/MarginContainer/Menu/Scale/my
@onready var mz: LineEdit = $HBox/MarginContainer/Menu/Scale/mz

func _ready() -> void:
	cube.translate(200, 0, 0)
	axis.translate(200, 0, 0)
	Engine.max_fps = 20

func _process(delta: float) -> void:
	return
	if (frame_count > 100):
		return
	frame_count += 1
	tetrahedron.translate(1, 1, 1)
	cube.translate(-1, -1, -1)
	queue_redraw()

func draw_object(obj: F.Spatial):
	for edge in obj.edges:
		var p1: F.Point = obj.points[edge.x].duplicate()
		var p2: F.Point = obj.points[edge.y].duplicate()
		
		var axonometric_matrix = F.AffineMatrices.get_axonometric_matrix(35, 45)
		
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

	
func _draw():
	#draw_object(tetrahedron)
	draw_object(cube)
	#draw_axis(axis)

func _on_apply_pressed() -> void:
	var translate_matrix = F.AffineMatrices.get_translation_matrix(float(dx.text),float(dy.text),float(dz.text))
	var rotate_matrix_x = F.AffineMatrices.get_rotation_matrix_about_x(float(ox.text))
	var rotate_matrix_y = F.AffineMatrices.get_rotation_matrix_about_x(float(oy.text))
	var rotate_matrix_z = F.AffineMatrices.get_rotation_matrix_about_x(float(oz.text))
	var scale_matrix = F.AffineMatrices.get_scale_matrix(float(mx.text),float(my.text), float(mz.text))
	cube.apply_matrix(translate_matrix)
	cube.apply_matrix(rotate_matrix_x)
	cube.apply_matrix(rotate_matrix_y)
	cube.apply_matrix(rotate_matrix_z)
	cube.apply_matrix(scale_matrix)
	queue_redraw()


func _on_clear_pressed() -> void:
	get_tree().reload_current_scene()
