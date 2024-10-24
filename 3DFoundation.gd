extends Node

class Point:
	var x: float
	var y: float
	
	func _init(x:float, y:float):
		self.x = x
		self.y = y
	
	func minus(p: Point):
		return Point.new(self.x - p.x, self.y - p.y)


class Polygon:
	var points: Array[Point]
	
	func _init() -> void:
		points = []
	func add(p: Point):
		points.append(p)
	func pop():
		points.pop_back()
	func clear():
		points.clear()
	
