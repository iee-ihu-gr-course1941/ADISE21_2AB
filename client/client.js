var renderStarted = Date.now();

const canvas = document.getElementById('canvas');
const ctx = canvas.getContext('2d');
const image = document.getElementById('source');

var image1 = new Image;
image1.src = 'https://legendmod.ml/banners/iconSpecialSkinEffectsHat3.png';

image.addEventListener('load', e => {
  ctx.drawImage(image, 33, 71, 104, 124, 21, 20, 87, 104);
});

ctx.clearRect(0, 0, this.canvasWidth, this.canvasHeight);
ctx.save();
