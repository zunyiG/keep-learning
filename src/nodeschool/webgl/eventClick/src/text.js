import { TextGeometry, FontLoader, MeshBasicMaterial, Mesh } from "three";
import font from 'three/examples/fonts/helvetiker_regular.typeface.json';

const loader = new FontLoader();
const material = new MeshBasicMaterial({ color: 0x0000ff })

export const createText = function (text) {
  const geometry = new TextGeometry(text, {
    font: loader.parse(font),
    size: 12,
    height: 1,
    curveSegments: 12,
    bevelEnabled: true,
    bevelThickness: 0.2,
    bevelSize: 0.05,
    bevelSegments: 1
  })

  const textInstance = new Mesh(geometry, material)
  return textInstance
}
