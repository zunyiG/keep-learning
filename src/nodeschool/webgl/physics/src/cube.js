const geometry = new THREE.BoxGeometry(10, 10, 10)
const material = new THREE.MeshBasicMaterial({ color: 0x00ff00 })

const defaultCube = new THREE.Mesh(geometry, material)

export const randomCube = function () {
  const random = Math.random()

  const geometry = new THREE.BoxGeometry(10 * (random + 0.3), 10 * (random + 0.3), 10 * (random + 0.3))
  const material = new THREE.MeshBasicMaterial({ color: 0xffffff * random })
  const mesh = new Physijs.BoxMesh(geometry, material)
  mesh.position.y = (random - 0.5) * 70
  return mesh
}

export default defaultCube
