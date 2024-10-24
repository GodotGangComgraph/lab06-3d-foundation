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
	func pop_back():
		edges.pop_back()
		points.pop_back()
		points.pop_back()
	func clear():
		points.clear()
		edges.clear()
