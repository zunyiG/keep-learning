import { createText } from "./text.js";

export const randomColor = function (intersects) {
  if (intersects.length > 0) {
    intersects[0].object.material.color.setHex(Math.random() * 0xffffff);
  }
}

export const addToList = function (intersects, list = []) {
  if (intersects.length > 0 && intersects[0].object.name === 'cube') {
    list.push(intersects[0].object)
  }
}

export const addScore = function (scene) {
  let score = 0
  let before = null
  return function (intersects) {
    if (intersects.length > 0 && intersects[0].object.name === 'cube') {
      score += 10
      createText('$ ' + score).then(scoreInstance => {
        scene.add(scoreInstance)
        scoreInstance.position.set(220, 150, -200)

        if (before) {
          scene.remove(before)
        }
        before = scoreInstance
      })
    }
  }
}
