export const addOnMouseDown = function addOnMouseDown (camera, objects, callback) {
  const onMouseDownHandle = (event) => {
    event.preventDefault();
    const raycaster = new THREE.Raycaster();
    const mouse = new THREE.Vector2()
    mouse.x = (event.clientX / window.innerWidth) * 2 - 1
    mouse.y = - (event.clientY / window.innerHeight) * 2 + 1
    raycaster.setFromCamera(mouse, camera)

    const intersects = raycaster.intersectObjects(objects.children);
    callback(intersects)
  }

  document.addEventListener('mousedown', onMouseDownHandle, false);
}

export const addOnDragRotation = function addOnMouseDown (objects) {
  const onDragHandle = (event) => {
    event.preventDefault();

    // objects
  }

  document.addEventListener('drag', onDragHandle, false);
}

