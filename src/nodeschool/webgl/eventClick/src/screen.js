import { BoxGeometry, MeshBasicMaterial, Mesh, Group } from "THREE";

const bgGeo = new BoxGeometry(9999999, 500, 1)
const bgMaterial = new MeshBasicMaterial({color: 0xffffff})
const bgMesh = new Mesh(bgGeo, bgMaterial)
bgMesh.position.set(0, -50, 400);

const groundGeo = new BoxGeometry(9999999, 1, 400)
const groundMaterial = new MeshBasicMaterial({color: 0x9fa0a8})
const groundMesh = new Mesh(groundGeo, groundMaterial)
groundMesh.position.set(0, -50, 2);

const screen = new Group()
screen.add(groundMesh).add(bgMesh)

export default screen
