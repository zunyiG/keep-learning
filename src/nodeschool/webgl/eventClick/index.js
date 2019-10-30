import { Scene, WebGLRenderer, Raycaster, Vector2 } from 'THREE';
import cube from './src/cube';
import lines from './src/lines';
import camera from './src/camera';
import text from './src/text';
import { addOnMouseDown } from './src/events';
import { randomColor } from './src/operates';

let scene = new Scene()

const render = new WebGLRenderer()
render.setSize(window.innerWidth, window.innerHeight)
document.body.appendChild(render.domElement)

scene.add(cube)
scene.add(lines)
scene.add(text)
addOnMouseDown(camera, scene, randomColor)

const animate = () => {
  requestAnimationFrame(animate);
  render.render(scene, camera)
  cube.rotation.y += 0.01;
  cube.rotation.x += 0.01;
}

window.onload = animate


