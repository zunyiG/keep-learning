import { LineBasicMaterial, Geometry, Vector3, Line } from "three";

const material = new LineBasicMaterial({ color: 0x0000ff })
const geometry = new Geometry()

geometry.vertices.push(new Vector3(-10, 0, 0))
geometry.vertices.push(new Vector3(0, 10, 0))
geometry.vertices.push(new Vector3(10, 0, 0))

const lines = new Line(geometry, material)

export default lines
