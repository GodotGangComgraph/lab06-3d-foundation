extends Control

var edge_length = 100

func _ready() -> void:
	var cube: F.Spatial = F.Spatial.new()
	cube.add_edge(Vector3(100, 100, 10), Vector3(100 + edge_length, 100, 10))
	cube.add_edge(Vector3(100, 100, 10), Vector3(100, 100, 10))
	cube.add_edge(Vector3(100, 100, 10), Vector3(100, 100, 10))
	cube.add_edge(Vector3(100, 100, 10), Vector3(100, 100, 10))
	cube.add_edge(Vector3(100, 100, 10), Vector3(100, 100, 10))
	cube.add_edge(Vector3(100, 100, 10), Vector3(100, 100, 10))
	cube.add_edge(Vector3(100, 100, 10), Vector3(100, 100, 10))
	cube.add_edge(Vector3(100, 100, 10), Vector3(100, 100, 10))
	cube.add_edge(Vector3(100, 100, 10), Vector3(100, 100, 10))
	cube.add_edge(Vector3(100, 100, 10), Vector3(100, 100, 10))
	cube.add_edge(Vector3(100, 100, 10), Vector3(100, 100, 10))
	cube.add_edge(Vector3(100, 100, 10), Vector3(100, 100, 10))
