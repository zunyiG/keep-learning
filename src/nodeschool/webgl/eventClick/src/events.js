import { Raycaster, Vector2 } from "THREE";

export const addOnMouseDown = function addOnMouseDown (camera, scene, callback) {
  const onMouseDownHandle = (event) => {
    event.preventDefault();

    const raycaster = new Raycaster();
    const mouse = new Vector2()
    mouse.x = (event.clientX / window.innerWidth) * 2 - 1
    mouse.y = - (event.clientY / window.innerHeight) * 2 + 1
    raycaster.setFromCamera(mouse, camera)

    const intersects = raycaster.intersectObjects(scene.children);

    callback(intersects)
  }

  document.addEventListener('mousedown', onMouseDownHandle, false);
}
