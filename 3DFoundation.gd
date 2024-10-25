class_name F extends Node

class AffineMatrices:

	static func get_translation_matrix(tx: float, ty: float, tz: float) -> DenseMatrix:
		var m = DenseMatrix.identity(4)
		m.set_element(3, 0, tx)
		m.set_element(3, 1, ty)
		m.set_element(3, 2, tz)
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
