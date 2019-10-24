var demo = (function(){

    "use strict";

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
            camera.position.set( 0, 100, 0 );
            camera.lookAt(new THREE.Vector3(0, 0, 100));

            scene.add(camera);

            box = new THREE.Mesh(
              new THREE.CubeGeometry(
                20,
                20,
                20),
              new THREE.MeshBasicMaterial({color: 0x00ff00}));

            box.position.set(0, 0, 100)
            scene.add(box);

            var childBox = new THREE.Mesh(
              new THREE.CubeGeometry(
                10,
                10,
                10
              ),
              new THREE.MeshBasicMaterial({color:0x0000ff})
            )

            childBox.name = 'boxChild'

            box.add(childBox)
            box.getObjectByName('boxChild').position.set(-20, 0, 0)
            console.log(box.getObjectByName('boxChild'));

            requestAnimationFrame(render);

          };
          let adder = 0.3
          function render() {
            // 01. - camera animation - //
            // if (camera.position.z > 300 || camera.position.z < 0) {
            //   adder = -adder
            // }
            // console.log(camera.position.z)
            // console.log(adder)
            // camera.position.z = camera.position.z + adder
            // camera.lookAt(new THREE.Vector3(0, 0, 100));

            // 02. - box animation - //
            // box.rotation.y += 0.01;
            // box.rotation.z += 0.01;
            // box.scale.x += 0.005
            // box.scale.y += 0.005
            // box.scale.z += 0.005

            // 03. - parent animation - //
            // if (box.position.x > 40 || box.position.x < -40) {
            //   adder = -adder
            // }
            // box.position.x += adder



          renderer.render(scene, camera);
          requestAnimationFrame(render);
        };

        window.onload = initScene;

})();
