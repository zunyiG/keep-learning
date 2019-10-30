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


      var groundBox = new THREE.CubeGeometry(1000, 1, 1000);
      var groundMaterial = new THREE.MeshBasicMaterial({ color: 0x33d038});
      var ground = new THREE.Mesh(groundBox, groundMaterial);
      ground.position.set(0,-10,0);
      scene.add(ground)

      var skyBox = new THREE.CubeGeometry(1000, 1000, 1);
      var skyMaterial = new THREE.MeshBasicMaterial({ color: 0x1cbef2});
      var sky = new THREE.Mesh(skyBox, skyMaterial);
      sky.position.set(0,0,-100);
      sky.rotation.y = 0.15;
      scene.add(sky)

      var cloudBox = new THREE.CubeGeometry(50, 10, 20);
      var cloudMaterial = new THREE.MeshBasicMaterial({ color: 0xd6f0fe});
      var cloud = new THREE.Mesh(cloudBox, cloudMaterial);
      cloud.position.set(0,160,-50);
      cloud.rotation.y = 0.15;
      scene.add(cloud)

      var cloud2Box = new THREE.CubeGeometry(50, 10, 20);
      var cloud2Material = new THREE.MeshBasicMaterial({ color: 0xd6f0fe});
      var cloud2 = new THREE.Mesh(cloud2Box, cloud2Material);
      cloud2.position.set(30,130,-99);
      cloud2.rotation.y = 0.15;
      scene.add(cloud2)

      var sunBox = new THREE.CircleGeometry(30, 32);
      var sunMaterial = new THREE.MeshBasicMaterial({ color: 0xffffdd});
      var sun = new THREE.Mesh(sunBox, sunMaterial);
      sun.position.set(30,130,-99);
      scene.add(sun)

      var treeBox = new THREE.CylinderGeometry(0, 35, 90, 64, 64 );
      var treeMaterial = new THREE.MeshBasicMaterial( {color: 0x266f00} );
      var tree = new THREE.Mesh( treeBox,treeMaterial );
      tree.position.set(-30, 0, 39);
      scene.add( tree );

      var tree2Box = new THREE.CylinderGeometry(0, 10, 20, 140, 1  );
      var tree2Material = new THREE.MeshBasicMaterial( {color: 0x266f00} );
      var tree2 = new THREE.Mesh( tree2Box,tree2Material );
      tree2.position.set(-60, 0, 39);
      scene.add( tree2 );

      loader.load('../assets/gooseFull.js', function (geometry) {
              var gooseMaterial = new THREE.MeshLambertMaterial({
                map: THREE.ImageUtils.loadTexture('../assets/goose.jpg')
            });

            mesh = new THREE.Mesh(geometry, gooseMaterial);
            mesh.scale.set(120, 120, 120);
            mesh.rotation.y = 0.5;
            mesh.position.set(0, 0, 0);

            scene.add(mesh);
      });

      requestAnimationFrame(render);

    };
    function render() {
      // mesh && (mesh.rotation.y += 0.01)
      renderer.render(scene, camera);
      requestAnimationFrame(render);
    };

    window.onload = initScene;
