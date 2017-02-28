$(document).ready(function() {

  $("a").click(function(event) {
    event.preventDefault();

    var link     = $(this).attr("href");
    var randoAni = "animated zoomOutDown"
    var i        = 0
    var j        = 0

    setInterval(function(){ 
      var id = "#" + i + "-" + j;

      animate(id, randoAni);

      if (j < 7) {
        j ++
      } else {
        i ++
        j = 0        
      };

    }, 20);

    setTimeout(function(){
      window.location.href = link;
    }, 1500);
  });

  animate = function(id, randoAni) {
    $(id).addClass(randoAni);
  }

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

            day.style.backgroundColor = data.color;
            day.style.color           = data.text_color;
            practiced.innerHTML       = "1";
            minutes.innerHTML         = minsPracticed + " mins";

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
            day.style.color           = "black";
            practiced.innerHTML       = "0";
            minutes.innerHTML         = "";

          }
      });
    }
  }

});