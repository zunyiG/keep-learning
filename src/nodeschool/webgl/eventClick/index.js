import { Scene, WebGLRenderer, Raycaster, Vector2 } from 'THREE';
import { randomCube } from './src/cube';
import camera from './src/camera';
import { addOnMouseDown } from './src/events';
import { randomColor, addToList } from './src/operates';
import screen from './src/screen';

let scene = new Scene()

const render = new WebGLRenderer()
render.setSize(window.innerWidth, window.innerHeight)
document.body.appendChild(render.domElement)

// scene.add(lines)
// scene.add(text)

const clickedList = []

scene.add(screen)
addOnMouseDown(camera, screen, item => addToList(item, clickedList))

let i = 0;
const animate = () => {
  requestAnimationFrame(animate);
  render.render(scene, camera)

  if (i % 90 === 0) {
    const cube = randomCube();
    cube.name = 'cube'
    screen.add(cube)
    cube.position.x = - (screen.position.x - 100)
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

  screen.position.x -= 0.2
  i++;
}

window.onload = animate
