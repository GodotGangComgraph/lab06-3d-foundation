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
	tetrahedron.translate(200, 200, 200)
	cube.translate(200, 200, 200)
	axis.translate(200, 200, 200)
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
		var p1: F.Point = obj.points[edge.x]
		var p2: F.Point = obj.points[edge.y]
		
		var axonometric_matrix = F.AffineMatrices.get_perspective_matrix(-1000)
		
		p1.apply_matrix(axonometric_matrix)
		p2.apply_matrix(axonometric_matrix)
		draw_line(p1.get_vec2d(), p2.get_vec2d(), Color.RED, 0.5, true)

func draw_axis(axis: F.Axis):
	var perspective_matrix = F.AffineMatrices.get_perspective_matrix(-1000)
	var p1: F.Point = axis.points[axis.edges[0].x]
	var p2: F.Point = axis.points[axis.edges[0].y]
	p1.apply_matrix(perspective_matrix)
	p2.apply_matrix(perspective_matrix)
	draw_line(p1.get_vec2d(), p2.get_vec2d(), Color.RED, 0.5, true)
	
	p1 = axis.points[axis.edges[1].x]
	p2 = axis.points[axis.edges[1].y]
	p1.apply_matrix(perspective_matrix)
	p2.apply_matrix(perspective_matrix)
	draw_line(p1.get_vec2d(), p2.get_vec2d(), Color.GREEN, 0.5, true)
	
	p1 = axis.points[axis.edges[2].x]
	p2 = axis.points[axis.edges[2].y]
	p1.apply_matrix(perspective_matrix)
	p2.apply_matrix(perspective_matrix)
	draw_line(p1.get_vec2d(), p2.get_vec2d(), Color.BLUE, 0.5, true)

	
func _draw():
	#draw_object(tetrahedron)
	draw_object(cube)

func _on_apply_pressed() -> void:
	var translate_matrix = F.AffineMatrices.get_translation_matrix(float(dx.text),float(dy.text),float(dz.text))
	cube.apply_matrix(translate_matrix)
	queue_redraw()
