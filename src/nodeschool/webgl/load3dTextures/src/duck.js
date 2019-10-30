import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
import glsl from './assets/grass.gltf';

const loader = new GLTFLoader()

const duck = new Promise((res, rej) => loader.load(glsl, gltf => res(gltf.scene), undefined, rej));

export default duck
