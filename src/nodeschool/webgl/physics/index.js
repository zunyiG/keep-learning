import { randomCube } from './src/cube.js';
import camera from './src/camera.js';
import { addOnMouseDown } from './src/events.js';
import { addToList, addScore } from './src/operates.js';
import screen from './src/screen.js';
import {createText} from './src/text.js';

window.onload = () => {
  Physijs.scripts.worker = './src/lib/physijs_worker.js';
  Physijs.scripts.ammo = './ammo.js';

  let scene = new Physijs.Scene();
  scene.setGravity(new THREE.Vector3( 10, 0, 0 ))

  const render = new THREE.WebGLRenderer()
  render.setSize(window.innerWidth, window.innerHeight)
  document.body.appendChild(render.domElement)

  // scene.add(lines)
  // scene.add(text)

  scene.add(screen)

  const axesHelper = new THREE.AxesHelper( 1000 );
  scene.add( axesHelper );

  const clickedList = []
  addOnMouseDown(camera, scene, item => addToList(item, clickedList))

  createText('score: ').then(scoreLabel => {
    scene.add(scoreLabel)
    scoreLabel.position.set(160, 150, -200)
  })


  addOnMouseDown(camera, scene, addScore(scene))

  let controls

  let i = 0;
  const animate = () => {
    controls && controls.update();
    scene.simulate();
    render.render(scene, camera)
    requestAnimationFrame(animate);

    if (i % 20 === 0) {
      const cube = randomCube();
      cube.name = 'cube'
      cube.position.x = -200
      scene.add(cube)
    }

    const cubes = scene.children
    for(const cube of cubes) {
      if (cube.name === 'cube') {
        cube.rotation.y += 0.02
        cube.rotation.z -= 0.01
      }
    }

    clickedList.forEach((cube, index) => {
      if (cube.name === 'cube') {
        if (cube.scale.x > 0.1) {
          cube.scale.x -= 0.1
          cube.scale.y -= 0.1
          cube.scale.z -= 0.1
        } else {
          clickedList.splice(index, 1)
          scene.remove(cube)
        }
      }
    })
    i++;
  }

  animate()

  controls = new window.THREE.OrbitControls( camera, render.domElement );
  controls.update();
}
