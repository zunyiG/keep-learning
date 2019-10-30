import { PerspectiveCamera } from "three"

const camera = new PerspectiveCamera(75, window.innerWidth/window.innerHeight, 0.1, 100)
camera.position.z = 100
camera.lookAt(0, 0, 0)

export default camera
