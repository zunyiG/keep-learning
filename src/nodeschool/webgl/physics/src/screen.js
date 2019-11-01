
const bgGeo = new THREE.BoxGeometry(9999999, 500, 1)
const bgMaterial = new THREE.MeshBasicMaterial({color: 0xffffff})
const bgMesh = new THREE.Mesh(bgGeo, bgMaterial)
bgMesh.position.set(0, -50, -400);

const groundGeo = new THREE.BoxGeometry(9999999, 1, 400)
const groundMaterial = new THREE.MeshBasicMaterial({color: 0x9fa0a8})
const groundMesh = new THREE.Mesh(groundGeo, groundMaterial)
groundMesh.position.set(0, -50, 2);

const screen = new THREE.Group()
screen.add(groundMesh).add(bgMesh)

export default screen
