import camera from './src/camera.js';
import { addOnMouseDown } from './src/events.js';
import { addToList, addScore } from './src/operates.js';
import {createText} from './src/text.js';

window.onload = () => {
  Physijs.scripts.worker = './src/lib/physijs_worker.js';
  Physijs.scripts.ammo = './ammo.js';

  let scene = new Physijs.Scene();
  scene.setGravity(new THREE.Vector3( 0, -50, 0 ))

  const render = new THREE.WebGLRenderer()
  render.setSize(window.innerWidth, window.innerHeight)
  document.body.appendChild(render.domElement)

  const axesHelper = new THREE.AxesHelper( 1000 );
  scene.add( axesHelper );

  // createText('score: ').then(scoreLabel => {
  //   scene.add(scoreLabel)
  //   scoreLabel.position.set(160, 150, -200)
  // })



  const controls = new window.THREE.OrbitControls( camera, render.domElement );

  const animate = () => {
    controls.update();
    scene.simulate();
    render.render(scene, camera)
    requestAnimationFrame(animate);
  }

  animate()
}
