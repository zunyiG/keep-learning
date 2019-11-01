const material = new THREE.LineBasicMaterial({ color: 0x0000ff })
const geometry = new THREE.Geometry()

geometry.vertices.push(new THREE.Vector3(-10, 0, 0))
geometry.vertices.push(new THREE.Vector3(0, 10, 0))
geometry.vertices.push(new THREE.Vector3(10, 0, 0))

const lines = new THREE.Line(geometry, material)

export default lines
