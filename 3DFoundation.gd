class_name F extends Control

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
		
	static func get_rotation_matrix_about_x(ox: float) -> DenseMatrix:
		var m = DenseMatrix.identity(4)
			
		var rot_deg_x = deg_to_rad(ox)
		var sin_x = sin(rot_deg_x)
		var cos_x = cos(rot_deg_x)
		
		m.set_element(1, 1, cos_x)
		m.set_element(1, 2, sin_x)
		m.set_element(2, 1, -sin_x)
		m.set_element(2, 2, cos_x)
		return m
		
	static func get_rotation_matrix_about_y(oy: float) -> DenseMatrix:
		var m = DenseMatrix.identity(4)
			
		var rot_deg_y = deg_to_rad(oy)
		var sin_y = sin(rot_deg_y)
		var cos_y = cos(rot_deg_y)
		
		m.set_element(0, 0, cos_y)
		m.set_element(0, 2, -sin_y)
		m.set_element(2, 0, sin_y)
		m.set_element(2, 2, cos_y)
		return m

	static func get_rotation_matrix_about_z(oz: float) -> DenseMatrix:
		var m = DenseMatrix.identity(4)
		
		var rot_deg_z = deg_to_rad(oz)
		var sin_z = sin(rot_deg_z)
		var cos_z = cos(rot_deg_z)
		
		m.set_element(0, 0, cos_z)
		m.set_element(0, 1, sin_z)
		m.set_element(1, 0, -sin_z)
		m.set_element(1, 1, cos_z)
		return m

	static func get_scale_matrix(mx: float, my: float, mz: float) -> DenseMatrix:
		var m = DenseMatrix.identity(4)
		
		if mx == 0:
			m.set_element(0, 0, 1)
		else:
			m.set_element(0, 0, mx)
		
		if my == 0:
			m.set_element(1, 1, 1)
		else:
			m.set_element(1, 1, my)
			
		if mz == 0:
			m.set_element(2, 2, 1)
		else:
			m.set_element(2, 2, mz)
		
		return m



class Point:
	var x: float
	var y: float
	var z: float
	var w: float
	
	func _init(_x: float, _y: float, _z: float) -> void:
		x = _x
		y = _y
		z = _z
		w = 1
	
	func duplicate() -> Point:
		var p = Point.new(0, 0, 0)
		p.x = x
		p.y = y
		p.z = z
		p.w = w
		return p

	func apply_matrix(matrix: DenseMatrix):
		var v = get_vector()
		var vnew = v.multiply_dense(matrix)
		x = vnew.get_element(0, 0)
		y = vnew.get_element(0, 1)
		z = vnew.get_element(0, 2)
		w = vnew.get_element(0, 3)
		
	func get_vector() -> DenseMatrix:
		return DenseMatrix.from_packed_array([x, y, z, w], 1, 4)
	
	func get_vec2d():
		return Vector2(x/w, y/w)
	
	func get_vec3d():
		return Vector3(x/w, y/w, z/w)

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
		
	func rotation_about_x(ox: float):
		var matrix: DenseMatrix = AffineMatrices.get_rotation_matrix_about_x(ox)	
		apply_matrix(matrix)
		
	func rotation_about_y(oy: float):
		var matrix: DenseMatrix = AffineMatrices.get_rotation_matrix_about_y(oy)	
		apply_matrix(matrix)	
		
	func rotation_about_z(oz: float):
		var matrix: DenseMatrix = AffineMatrices.get_rotation_matrix_about_z(oz)	
		apply_matrix(matrix)	
		
	func scale(mx: float, my: float, mz: float):
		var matrix: DenseMatrix = AffineMatrices.get_scale_matrix(mx, my, mz)
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
