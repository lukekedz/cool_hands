$(document).ready(function() {

  // <a href="/?id=2">February</a>
  $( "a" ).click(function(event) {
    event.preventDefault();

    var Link = $(this).attr("href");

    var rows = 5;
    var blox = 7;
    for(var i=0; i < rows; i++){
      console.log(i);

      for(var j=0; j < blox; j++){
        // console.log(j);

        // var it = document.getElementById(i + "-" + j);
        // console.log(it);

          var it = "#" + i + "-" + j
          // console.log(it);
          $(it).addClass('animated rotateOutUpLeft');

          setTimeout(function(){


          }, 10000);
      }
    }

    console.log(event);
    setTimeout(function(){
      window.location.href = Link;
    }, 1000);
  });



  // https://daneden.github.io/animate.css/
  var animations = [ "flip", "flipInX", "flipInY" ]

  practiced = function(event, dayId) {

    var day = document.getElementById(event.target.id);
    var id  = "#" + event.target.id;
    // console.log(day.childNodes);

    var practiced = day.childNodes[1];
    var minutes   = day.childNodes[7];

    if (practiced.innerHTML === "0") {
      var minsPracticed = prompt("Enter practice time (in minutes):");

      $.ajax({
          type: "POST",
          url: "/site/practiced",
          data: { "day_id": dayId, "practiced": 1, "minutes": minsPracticed },
          success: function(data){
            var randoAni = "animated " + animations[Math.floor((Math.random() * 3))];
            $(id).addClass(randoAni);
            // $(id).addClass("animated zoomIn");

            day.style.backgroundColor = data.color;
            practiced.innerHTML = "1";
            minutes.innerHTML   = minsPracticed + " mins";

          }
      });
    } else {

      $.ajax({
          type: "POST",
          url: "/site/practiced",
          data: { "day_id": dayId, "practiced": 0 },
          success: function(data){
            $(id).addClass("animated zoomIn");

            day.style.backgroundColor = "transparent";
            practiced.innerHTML = "0";
            minutes.innerHTML   = "";

          }
      });
    }
  }

});