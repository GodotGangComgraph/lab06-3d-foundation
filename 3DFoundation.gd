class_name F
extends Node


class Spatial:
	var points: Array[Vector3]
	var edges: Array[Vector2i]
	#var faces #Array[Array[int]]
	
	func add_edge(p1: Vector3, p2: Vector3):
		points.append(p1)
		points.append(p2)
		edges.append(Vector2i(points.size() - 2, points.size() - 1))
	
	func clear():
		points.clear()
		edges.clear()


class Cube extends Spatial:
	func _init():
		var l = 100
		
		points = [
			Vector3(-l, -l, -l), Vector3(l, -l, -l), Vector3(l, l, -l), Vector3(-l, l, -l),
			Vector3(-l, -l, l), Vector3(l, -l, l), Vector3(l, l, l), Vector3(-l, l, l)
		]
		
		for i in range(points.size()):
			points[i] += Vector3(200, 200, 200)
		
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
			Vector3(l, l, l),
			Vector3(-l, -l, l),
			Vector3(-l, l, -l),
			Vector3(l, -l, -l)
		]
		
		for i in range(points.size()):
			points[i] += Vector3(200, 200, 200)
		
		var edge_pairs = [
			Vector2i(0, 1), Vector2i(0, 2), Vector2i(0, 3),
			Vector2i(1, 2), Vector2i(1, 3), Vector2i(2, 3)
		]
		
		for pair in edge_pairs:
			add_edge(points[pair.x], points[pair.y])
