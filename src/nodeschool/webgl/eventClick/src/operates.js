export const randomColor = function (intersects) {
  if (intersects.length > 0) {
    intersects[0].object.material.color.setHex(Math.random() * 0xffffff);
  }
}

export const addToList = function (intersects, list = []) {
  if (intersects.length > 0) {
    list.push(intersects[0].object)
  }
}
