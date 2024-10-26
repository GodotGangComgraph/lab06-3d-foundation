class_name F extends Control

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
	
	static func get_perspective_matrix(c: float) -> DenseMatrix:
		var m = DenseMatrix.identity(4)
		m.set_element(2, 2, 0)
		m.set_element(2, 3, -1.0/c)
		return m

	static func get_axonometric_matrix(phi_deg: float, psi_deg: float) -> DenseMatrix:
		var phi = deg_to_rad(phi_deg)
		var psi = deg_to_rad(psi_deg)
		var m = DenseMatrix.zero(4)
		m.set_element(0, 0, cos(psi))
		m.set_element(0, 1, sin(psi) * cos(phi))
		m.set_element(1, 1, cos(phi))
		m.set_element(2, 0, sin(psi))
		m.set_element(2, 1, -sin(phi) * cos(psi))
		m.set_element(3, 3, 1)
		return m
		

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
		x = vnew.get_element(0, 0) / vnew.get_element(0, 3) 
		y = vnew.get_element(0, 1) / vnew.get_element(0, 3)
		z = vnew.get_element(0, 2) / vnew.get_element(0, 3)
		pass
		
	func get_vector() -> DenseMatrix:
		return DenseMatrix.from_packed_array([x, y, z, 1], 1, 4)
	
	func get_vec2d():
		return Vector2(x, y)
	
	func get_vec3d():
		return Vector3(x, y, z)

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
		
	func translate(tx: float, ty: float, tz: float):
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
		var lst_points = [
			Point.new(-l, -l, -l)	, Point.new(l, -l, -l),
			Point.new(l, l, -l)		, Point.new(-l, l, -l),
			Point.new(-l, -l, l)	, Point.new(l, -l, l), 
			Point.new(l, l, l)		, Point.new(-l, l, l)
		]
		var edge_pairs = [
			Vector2i(0, 1), Vector2i(1, 2), Vector2i(2, 3), Vector2i(3, 0),
			Vector2i(4, 5), Vector2i(5, 6), Vector2i(6, 7), Vector2i(7, 4),
			Vector2i(0, 4), Vector2i(1, 5), Vector2i(2, 6), Vector2i(3, 7)
		]
		for pair in edge_pairs:
			add_edge(lst_points[pair.x], lst_points[pair.y])


class Tetrahedron extends Spatial:
	func _init():
		var l = 100
		
		## THIS IS NOT POINTS FROM SPATIAL
		var lst_points = [
			Point.new(l, l, l),
			Point.new(-l, -l, l),
			Point.new(-l, l, -l),
			Point.new(l, -l, -l)
		]
		
		## THIS IS NOT EDGES FROM SPATIAL
		var edge_pairs = [
			Vector2i(0, 1), Vector2i(0, 2), Vector2i(0, 3),
			Vector2i(1, 2), Vector2i(1, 3), Vector2i(2, 3)
		]
		
		for pair in edge_pairs:
			add_edge(lst_points[pair.x], lst_points[pair.y])

class Axis extends Spatial:
	func _init():
		var l = 100
		
		## THIS IS NOT POINTS FROM SPATIAL
		var lst_points = [
			Point.new(0, 0, 0),
			Point.new(l, 0, 0),
			Point.new(0, l, 0),
			Point.new(0, 0, l),
		]
		
		## THIS IS NOT EDGES FROM SPATIAL
		var edge_pairs = [
			Vector2i(0, 1), Vector2i(0, 2), Vector2i(0, 3),
		]
		
		for pair in edge_pairs:
			add_edge(lst_points[pair.x], lst_points[pair.y])	
