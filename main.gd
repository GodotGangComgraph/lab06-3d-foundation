extends Control


var edge_length = 100

var aspect_ratio = 1
var near = 500.0
var fov = 200.0

var cube = F.Cube.new()
var tetrahedron = F.Tetrahedron.new()

# Perspective projection function
func perspective_project(point: F.Point) -> Vector2:
	var scale_ = near / (point.z + fov)
	return Vector2(point.x * scale_ * aspect_ratio, point.y * scale_)


## Perspective projection function
#func perspective_project(point: Vector3) -> Vector2:
	#var m = DenseMatrix.zero(4)
	#m.set_element(0, 0, n)
	#m.set_element(1, 1, n)
	#m.set_element(2, 2, f+n)
	#m.set_element(2, 3, -f*n)
	#m.set_element(3, 2, 1)
	#var v = DenseMatrix.from_packed_array([point.x, point.y, point.z, 1], 4, 1)
	#var res = m.multiply_dense(v)
	#
	#return Vector2(res.get_element(0, 0), res.get_element(0, 1))

var frame_count = 0

func _ready() -> void:
	Engine.max_fps = 20
func _process(delta: float) -> void:
	if (frame_count > 100):
		return
	frame_count += 1
	tetrahedron.translate(0, 0, 1)
	queue_redraw()
	
func _draw():
	# Drawing the cube in 2D space with perspective projection
	for edge in tetrahedron.edges:
		var p1 = tetrahedron.points[edge.x]
		var p2 = tetrahedron.points[edge.y]
		
		# Apply perspective projection to 2D
		var projected_p1 = perspective_project(p1)
		var projected_p2 = perspective_project(p2)
		
		#print(projected_p1, projected_p2)
		# Draw the edges (replace with actual drawing code)
		draw_line(projected_p1, projected_p2, Color.RED)
