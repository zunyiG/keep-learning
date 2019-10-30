import * as THREE from 'THREE';
import cube from './src/cube';
import lines from './src/lines';
import camera from './src/camera';
import text from './src/text';
import duck from './src/duck';

let scene = new THREE.Scene()

const render = new THREE.WebGLRenderer()
render.setSize(window.innerWidth, window.innerHeight)
document.body.appendChild(render.domElement)

// scene.add(cube)
// scene.add(lines)
// scene.add(text)
let innerSc
const animate = () => {
  requestAnimationFrame(animate);
  render.render(scene, camera)
  if (innerSc) {
    innerSc.rotation.y += 0.01;
    innerSc.rotation.x += 0.01;
  }
}

duck.then(sc => {
  innerSc = sc
  sc.scale.set(3,3,3)
  sc.position.set(0,0,0)
  // camera.position.set(0, 200, 100)
  camera.lookAt(0,0,0)
  scene.add(sc)
  console.log(sc);
}).then(animate).catch(console.log)

// window.onload = animate
