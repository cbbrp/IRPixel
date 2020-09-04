var audio = new Audio("https://irpixel.ir/loading.mp3");
var slideIndex = 1;

$(document).keypress(function(event) {
    var key = (event.keyCode ? event.keyCode : event.which);
    if (key == 32)
    {
        event.preventDefault()
        toggle()  
    }
});

function Display(){
    plusDivs(1)
}
setInterval(Display, 7000)

$(document).ready(function () {
    audio.volume = 0.4;
    audio.loop = true
    audio.play()
});


showDivs(slideIndex);

function plusDivs(n) {
  showDivs(slideIndex += n);
}

function showDivs(n) {
  var i;
  var x = document.getElementsByClassName("mySlides");
  if (n > x.length) {slideIndex = 1}
  if (n < 1) {slideIndex = x.length}
  for (i = 0; i < x.length; i++) {
    x[i].style.display = "none";
  }
  x[slideIndex-1].style.display = "block";
}

function toggle() {
    if (audio.paused){
        $("#toggle").attr("src","https://irpixel.ir/images/unmute.png")
        audio.volume = 0.4;
        audio.play()
    } else {
        $("#toggle").attr("src","https://irpixel.ir/images/mute.png")
        audio.pause()
    }
}