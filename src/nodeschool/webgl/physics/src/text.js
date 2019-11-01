const loader = new THREE.FontLoader();
const material = new THREE.MeshBasicMaterial({ color: 0x0000ff })

export const createText = function (text) {
  return new Promise((res, rej) => {
    loader.load('/src/assets/helvetiker_regular.typeface.json', font => {
      const geometry = new THREE.TextGeometry(text, {
        font: font,
        size: 12,
        height: 1,
        curveSegments: 12,
        bevelEnabled: true,
        bevelThickness: 0.2,
        bevelSize: 0.05,
        bevelSegments: 1
      })

      const textInstance = new THREE.Mesh(geometry, material)
      res(textInstance)
    })
  })
}
