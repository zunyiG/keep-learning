var scene=new THREE.Scene(),
    light= new THREE.AmbientLight(0xffffff),
    renderer,
    camera,
    renderer = new THREE.WebGLRenderer(),
    box,
    ground,
    mesh,
    loader = new THREE.JSONLoader(),
    controls=null;

    function initScene(){

      renderer.setSize( window.innerWidth, window.innerHeight );
      document.getElementById("webgl-container").appendChild(renderer.domElement);

      scene.add(light);

      camera = new THREE.PerspectiveCamera(
              20,
              window.innerWidth / window.innerHeight,
              0.1,
              2000
          );
      camera.position.set( 0, 900, 600 );
      camera.lookAt(new THREE.Vector3(0, 75, 0));

      scene.add(camera);

      loader.load('../assets/gooseFull.js', function (geometry) {
                var gooseMaterial = new THREE.MeshLambertMaterial({
                map: THREE.ImageUtils.loadTexture('../assets/goose.jpg')
            });

            mesh = new THREE.Mesh(geometry, gooseMaterial);
            mesh.scale.set(150, 150, 150);
            mesh.position.set(0, 0, 0);

            scene.add(mesh);
      });

      requestAnimationFrame(render);

    };
    function render() {
      mesh && (mesh.rotation.y += 0.01)
      renderer.render(scene, camera);
      requestAnimationFrame(render);
    };

    window.onload = initScene;
