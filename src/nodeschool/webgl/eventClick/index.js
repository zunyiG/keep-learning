import { Scene, WebGLRenderer, AxesHelper } from 'three';
import { randomCube } from './src/cube';
import camera from './src/camera';
import { addOnMouseDown } from './src/events';
import { randomColor, addToList, addScore } from './src/operates';
import screen from './src/screen';
import {createText} from './src/text';

let scene = new Scene()

const render = new WebGLRenderer()
render.setSize(window.innerWidth, window.innerHeight)
document.body.appendChild(render.domElement)

// scene.add(lines)
// scene.add(text)


scene.add(screen)

// const axesHelper = new AxesHelper( 1000 );
// scene.add( axesHelper );

const clickedList = []
addOnMouseDown(camera, screen, item => addToList(item, clickedList))

const scoreLabel = createText('score: ')
scene.add(scoreLabel)
scoreLabel.position.set(160, 150, -200)

addOnMouseDown(camera, screen, addScore(scene))

let controls

let i = 0;
const animate = () => {
  requestAnimationFrame(animate);
  controls && controls.update();
  render.render(scene, camera)

  if (i % 90 === 0) {
    const cube = randomCube();
    cube.name = 'cube'
    screen.add(cube)
    cube.position.x = -(screen.position.x + 130)
  }

  const cubes = screen.children
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
        screen.remove(cube)
      }
    }
  })

  screen.position.x += 0.2
  i++;
}

window.onload = () => {
  controls = new window.THREE.OrbitControls( camera, render.domElement );
  controls.update();

  animate()
}
