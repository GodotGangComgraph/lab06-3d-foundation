class_name F extends Node

@onready var dx = $VBoxContainer/MarginContainer/VBoxContainer2/traslate/dx
@onready var dy = $VBoxContainer/MarginContainer/VBoxContainer2/traslate/dy
@onready var dz = $VBoxContainer/MarginContainer/VBoxContainer2/traslate/dz

@onready var rot_x = $VBoxContainer/MarginContainer/VBoxContainer2/rotate/rot_x
@onready var rot_y = $VBoxContainer/MarginContainer/VBoxContainer2/rotate/rot_y
@onready var rot_z = $VBoxContainer/MarginContainer/VBoxContainer2/rotate/rot_z

@onready var sc_x = $VBoxContainer/MarginContainer/VBoxContainer2/sclae/sc_x
@onready var sc_y = $VBoxContainer/MarginContainer/VBoxContainer2/sclae/sc_y
@onready var sc_z = $VBoxContainer/MarginContainer/VBoxContainer2/sclae/sc_z


class AffineMatrices:

	static func get_translation_matrix(tx: float, ty: float, tz: float) -> DenseMatrix:
		var m = DenseMatrix.identity(4)
		m.set_element(3, 0, tx)
		m.set_element(3, 1, ty)
		m.set_element(3, 2, tz)
		return m
		
	static func get_rotation_matrix_about_x() -> DenseMatrix:
		var m = DenseMatrix.identity(4)
		m.set_element(1, 1, cos(0.0))
		m.set_element(1, 2, sin(0.0))
		m.set_element(2, 1, -sin(0.0))
		m.set_element(2, 2, cos(0.0))
		return m
		
	static func get_rotation_matrix_about_y() -> DenseMatrix:
		var m = DenseMatrix.identity(4)
		m.set_element(0, 0, cos(0.0))
		m.set_element(0, 2, -sin(0.0))
		m.set_element(2, 0, sin(0.0))
		m.set_element(2, 2, cos(0.0))
		return m

	static func get_rotation_matrix_about_z() -> DenseMatrix:
		var m = DenseMatrix.identity(4)
		m.set_element(0, 0, cos(0.0))
		m.set_element(0, 1, sin(0.0))
		m.set_element(1, 0, -sin(0.0))
		m.set_element(1, 1, cos(0.0))
		return m

	static func get_scale_matrix() -> DenseMatrix:		
		var m = DenseMatrix.identity(4)
		m.set_element(0, 0, 1)
		m.set_element(1, 1, 1)
		m.set_element(2, 2, 1)
		return m
							
class Point:
	var x: float
	var y: float
	var z: float
	func _init(_x: float, _y: float, _z: float) -> void:
		x = _x
		y = _y
		z = _z
		
	func apply_matrix(matrix: DenseMatrix):
		var v = get_vector()
		var vnew = v.multiply_dense(matrix)
		x = vnew.get_element(0, 0) 
		y = vnew.get_element(0, 1) 
		z = vnew.get_element(0, 2) 
		pass
		
	func get_vector() -> DenseMatrix:
		return DenseMatrix.from_packed_array([x, y, z, 1], 1, 4)

class Spatial:
	var points: Array[Point]
	var edges: Array[Vector2i]
	#var faces #Array[Array[int]]
	
	func add_edge(p1: Point, p2: Point):
		points.append(p1)
		points.append(p2)
		edges.append(Vector2i(points.size() - 2, points.size() - 1))
	
	func clear():
		points.clear()
		edges.clear()
	
	func apply_matrix(matrix: DenseMatrix):
		for i in range(points.size()):
			points[i].apply_matrix(matrix)
		
	func translate(tx, ty, tz):
		var matrix: DenseMatrix = AffineMatrices.get_translation_matrix(tx, ty, tz)
		apply_matrix(matrix)
		
	func rotation_about_x():
		var matrix: DenseMatrix = AffineMatrices.get_rotation_matrix_about_x()	
		apply_matrix(matrix)
		
	func rotation_about_y():
		var matrix: DenseMatrix = AffineMatrices.get_rotation_matrix_about_y()	
		apply_matrix(matrix)	
		
	func rotation_about_z():
		var matrix: DenseMatrix = AffineMatrices.get_rotation_matrix_about_z()	
		apply_matrix(matrix)	
		
	func scale():
		var matrix: DenseMatrix = AffineMatrices.get_scale_matrix()
		apply_matrix(matrix)	
		
class Cube extends Spatial:
	func _init():
		var l = 100
		points = [
			Point.new(-l, -l, -l)	, Point.new(l, -l, -l),
			Point.new(l, l, -l)		, Point.new(-l, l, -l),
			Point.new(-l, -l, l)	, Point.new(l, -l, l), 
			Point.new(l, l, l)		, Point.new(-l, l, l)
		]
		translate(200, 200, 200)
		var edge_pairs = [
			Vector2i(0, 1), Vector2i(1, 2), Vector2i(2, 3), Vector2i(3, 0),
			Vector2i(4, 5), Vector2i(5, 6), Vector2i(6, 7), Vector2i(7, 4),
			Vector2i(0, 4), Vector2i(1, 5), Vector2i(2, 6), Vector2i(3, 7)
		]
		for pair in edge_pairs:
			add_edge(points[pair.x], points[pair.y])


class Tetrahedron extends Spatial:
	func _init():
		var l = 100
		
		points = [
			Point.new(l, l, l),
			Point.new(-l, -l, l),
			Point.new(-l, l, -l),
			Point.new(l, -l, -l)
		]
		
		translate(200, 200, 200)
		
		var edge_pairs = [
			Vector2i(0, 1), Vector2i(0, 2), Vector2i(0, 3),
			Vector2i(1, 2), Vector2i(1, 3), Vector2i(2, 3)
		]
		
		for pair in edge_pairs:
			add_edge(points[pair.x], points[pair.y])
