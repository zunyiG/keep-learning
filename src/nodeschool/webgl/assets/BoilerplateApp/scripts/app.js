var scene=new THREE.Scene(),
    light= new THREE.AmbientLight(0xffffff),
    renderer,
    camera,
    renderer = new THREE.WebGLRenderer(),
    box,
    ground,
    controls=null;

    function initScene(){

        renderer.setSize( window.innerWidth, window.innerHeight );
        document.getElementById("webgl-container").appendChild(renderer.domElement);

        scene.add(light);

        camera = new THREE.PerspectiveCamera(
                35,
                window.innerWidth / window.innerHeight,
                1,
                1000
            );
        camera.position.set( 60, 100, 500 );
        camera.lookAt(new THREE.Vector3(0, 0, 0));

        scene.add(camera);
        var loader = new THREE.JSONLoader(),
        mesh;

        loader.load('../assets/gooseFull.js', function (geometry) {
                  var gooseMaterial = new THREE.MeshLambertMaterial({
                  map: THREE.ImageUtils.loadTexture('../assets/goose.jpg')
              });

              mesh = new THREE.Mesh(geometry, gooseMaterial);
              mesh.scale.set(150, 150, 150);
              mesh.position.set(0, -150, -200);

              scene.add(mesh);
        });

        requestAnimationFrame(render);

      };
    function render() {
      renderer.render(scene, camera);
      requestAnimationFrame(render);
    };

    window.onload = initScene;
