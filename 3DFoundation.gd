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
	
	static func get_rotation_x_by_sin_cos(sin_x: float, cos_x: float) -> DenseMatrix:
		var m = DenseMatrix.identity(4)
		m.set_element(1, 1, cos_x)
		m.set_element(1, 2, sin_x)
		m.set_element(2, 1, -sin_x)
		m.set_element(2, 2, cos_x)
		return m
		
	static func get_rotation_y_by_sin_cos(sin_y: float, cos_y: float) -> DenseMatrix:
		var m = DenseMatrix.identity(4)
		m.set_element(0, 0, cos_y)
		m.set_element(0, 2, -sin_y)
		m.set_element(2, 0, sin_y)
		m.set_element(2, 2, cos_y)
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
	
	static func get_line_rotate_matrix(l, m, n, sin_phi, cos_phi) -> DenseMatrix:
		var matr = DenseMatrix.identity(4)
		matr.set_element(0, 0, l*l+cos_phi*(1-l*l))
		matr.set_element(0, 1, l*(1-cos_phi)*m+n*sin_phi)
		matr.set_element(0, 2, l*(1-cos_phi)*n-m*sin_phi)
		matr.set_element(1, 0, l*(1-cos_phi)*m-n*sin_phi)
		matr.set_element(1, 1, m*m+cos_phi*(1-m*m))
		matr.set_element(1, 2, m*(1-cos_phi)*n+l*sin_phi)
		matr.set_element(2, 0, l*(1-cos_phi)*n+m*sin_phi)
		matr.set_element(2, 1, m*(1-cos_phi)*n-l*sin_phi)
		matr.set_element(2, 2, n*n+cos_phi*(1-n*n))
		return matr
		
		
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
	
	static func from_vec3d(_p: Vector3) -> Point:
		var p = Point.new(0,0,0)
		return p
	
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
	
	func translate(tx: float, ty: float, tz: float):
		var matrix = AffineMatrices.get_translation_matrix(tx, ty, tz)
		apply_matrix(matrix)
	
	func rotate_ox(ox: float):
		var matrix = AffineMatrices.get_rotation_matrix_about_x(ox)
		apply_matrix(matrix)
	
	func rotate_oy(oy: float):
		var matrix = AffineMatrices.get_rotation_matrix_about_y(oy)
		apply_matrix(matrix)
	
	func rotate_oz(oz: float):
		var matrix = AffineMatrices.get_rotation_matrix_about_z(oz)
		apply_matrix(matrix)
		
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
	
	func get_middle():
		var mid: Vector3 = Vector3.ZERO
		for point in points:
			mid += point.get_vec3d()
		return Point.from_vec3d(mid / points.size())
	
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
	
	func rotation_about_center(p: Point, ox: float, oy: float, oz: float):
		translate(-p.x, -p.y, -p.z)
		rotation_about_x(float(ox))
		rotation_about_y(float(oy))
		rotation_about_z(float(oz))
		translate(p.x, p.y, p.z)
	
	func rotation_about_line(p: Point, vec: Vector3, deg: float):
		deg = deg_to_rad(deg)
		vec = vec.normalized()
		
		var n = vec.z
		var m = vec.y
		var l = vec.x
		var d = sqrt(m * m + n * n)
		var matrix = AffineMatrices.get_line_rotate_matrix(l, m, n, sin(deg), cos(deg))
		apply_matrix(matrix)
	'''	translate(-p.x, -p.y, -p.z)
		
		var line_point = Point.from_vec3d(vec)
		var n = vec.z
		var m = vec.y
		var l = vec.x
		var d = sqrt(m * m + n * n)
		var matrix = AffineMatrices.get_rotation_x_by_sin_cos(m/d, n/d)
		apply_matrix(matrix)
		matrix = AffineMatrices.get_rotation_y_by_sin_cos(-d, l)
		apply_matrix(matrix)
		rotation_about_z(deg)
		
		matrix = AffineMatrices.get_rotation_y_by_sin_cos(d, l)
		apply_matrix(matrix)
		
		matrix = AffineMatrices.get_rotation_y_by_sin_cos(-m/d, n/d)
		apply_matrix(matrix)
		
		translate(p.x, p.y, p.z)'''
	
	func scale_about_center(p: Point, ox: float, oy: float, oz: float):
		translate(-p.x, -p.y, -p.z)
		scale_(ox, oy, oz)
		translate(p.x, p.y, p.z)
	
	func scale_(mx: float, my: float, mz: float):
		var matrix: DenseMatrix = AffineMatrices.get_scale_matrix(mx, my, mz)
		apply_matrix(matrix)
	
	func miror(mx: float, my: float, mz: float):
		var matrix = DenseMatrix.identity(4)
		matrix.set_element(0, 0, mx)
		matrix.set_element(1, 1, my)
		matrix.set_element(2, 2, mz)
		apply_matrix(matrix)
	
class Cube extends Spatial:
	func _init():
		var edge_length = 100
		var l = edge_length/2
		
		var lst_points = [
			Point.new(-l, -l, -l),	Point.new(l, -l, -l),
			Point.new(l, l, -l),		Point.new(-l, l, -l),
			Point.new(-l, -l, l),		Point.new(l, -l, l), 
			Point.new(l, l, l),		Point.new(-l, l, l)
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
		var edge_length = 100
		var l = edge_length/2
		
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


class Octahedron extends Spatial:
	func _init():
		var edge_length = 100
		var l = edge_length/sqrt(2)
		
		var lst_points = [
			Point.new(l, 0, 0),   # Вершина по оси X
			Point.new(-l, 0, 0),  # Вершина по оси -X
			Point.new(0, l, 0),   # Вершина по оси Y
			Point.new(0, -l, 0),  # Вершина по оси -Y
			Point.new(0, 0, l),   # Вершина по оси Z
			Point.new(0, 0, -l)   # Вершина по оси -Z
		]
		
		var edge_pairs = [
			Vector2i(0, 2), Vector2i(0, 3), Vector2i(0, 4), Vector2i(0, 5),
			Vector2i(1, 2), Vector2i(1, 3), Vector2i(1, 4), Vector2i(1, 5),
			Vector2i(2, 4), Vector2i(2, 5), Vector2i(3, 4), Vector2i(3, 5)
		]
		
		for pair in edge_pairs:
			add_edge(lst_points[pair.x], lst_points[pair.y])


class Icosahedron extends Spatial:
	func _init():
		var l = 100  # Высота цилиндра и длина вдоль оси z
		var r = l * sqrt(2) / 2  # Радиус вписанного цилиндра
		
		# Координаты 12 вершин икосаэдра
		var lst_points = [
			Point.new(r, 0, l/2),  Point.new(0, r, l/2),
			Point.new(-r, 0, l/2),  Point.new(0, -r, l/2),
			Point.new(r, r, 0), Point.new(-r, r, 0),
			Point.new(-r, -r, 0), Point.new(r, -r, 0),

	# Нижний уровень
			Point.new(r, 0, -l/2), Point.new(0, r, -l/2),
			Point.new(-r, 0, -l/2), Point.new(0, -r, -l/2)
		]
		
		# Определяем рёбра между вершинами
		var edge_pairs = [
			Vector2i(0, 1), Vector2i(1, 2), Vector2i(2, 3), Vector2i(3, 0),  # Верхний уровень
			Vector2i(4, 5), Vector2i(5, 6), Vector2i(6, 7), Vector2i(7, 4),  # Средний уровень
			Vector2i(8, 9), Vector2i(9, 10), Vector2i(10, 11), Vector2i(11, 8), # Нижний уровень
			Vector2i(0, 4), Vector2i(1, 5), Vector2i(2, 6), Vector2i(3, 7),  # Верхний - Средний
			Vector2i(8, 4), Vector2i(9, 5), Vector2i(10, 6), Vector2i(11, 7)  # Нижний - Средний
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
