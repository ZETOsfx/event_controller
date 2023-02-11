let img1 = document.getElementById("Imaga1");
let img2 = document.getElementById("Imaga2");
let img3 = document.getElementById("Imaga3");
let img4 = document.getElementById("Imaga4");

img1.addEventListener("mouseenter", function(event) {
  let sound = document.getElementById("Sound1");
  var buffer = .44;
    if (sound.currentTime > sound.duration - buffer) {
        sound.currentTime = 0;
        sound.play();
    } else {
        sound.play();
    }
}, false);

img2.addEventListener("mouseenter", function(event) {
    let sound = document.getElementById("Sound2");
    var buffer = .44;
    if (sound.currentTime > sound.duration - buffer) {
        sound.currentTime = 0;
        sound.play();
    } else {
        sound.play();
    }
}, false);

img3.addEventListener("mouseenter", function(event) {
    let sound = document.getElementById("Sound3");
    var buffer = .44;
    if (sound.currentTime > sound.duration - buffer) {
        sound.currentTime = 0;
        sound.play();
    } else {
        sound.play();
    }
}, false);

img4.addEventListener("mouseenter", function(event) {
    let sound = document.getElementById("Sound4");
    var buffer = .44;
    if (sound.currentTime > sound.duration - buffer) {
        sound.currentTime = 0;
        sound.play();
    } else {
        sound.play();
    }
}, false);