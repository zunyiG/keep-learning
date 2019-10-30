import { PerspectiveCamera } from "three"

const camera = new PerspectiveCamera(75, window.innerWidth/window.innerHeight, 0.1, 1000)
camera.position.z = 120
camera.position.y = 20
camera.lookAt(0, 20, 0)

export default camera
