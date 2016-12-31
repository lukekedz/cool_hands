$(document).ready(function() {

  // saturation = [ "#ffe6e6", "#ffcccc", "#ffb3b3", "#ff9999", "#ff8080", "#ff6666", "#ff4d4d", "#ff3333", "#ff1a1a", "#ff0000" ]

  // color = function(streak) {
  //   return "background-color: " + saturation[streak];
  // }

  clickable = function(event, blockId) {
    // console.log(event);
    // console.log(blockId);

    var id   = event.target.id;
    var mins = 0;
    var day = document.getElementById(id);
    // var practiced = day.childNodes[1];
    // console.log(practiced);

    if (day.childNodes[1].innerHTML === "0") {
      mins = prompt("Enter practice time (in minutes):");
    }
    // console.log(mins);

    if (day.className === 'day') {
        day.className = 'green';

      $.ajax({
          type: "POST",
          url: "/site/practiced",
          data: { "block_id": blockId, "practiced": 1, "minutes": mins },
          // success: function(data){
            // console.log(data);
            // if (mins != "") {
              // day.childNodes[7].innerHTML = mins + " mins";
            // } else {
              // day.childNodes[7].innerHTML = "";
            // }
            // day.childNodes[1].innerHTML = "1";
          // }
      });
    } else {
        day.className = 'day';

        $.ajax({
            type: "POST",
            url: "/site/practiced",
            data: { "block_id": blockId, "practiced": 0, "minutes": null },
            // success: function(data){
            //   // console.log(data);
            //   day.childNodes[7].innerHTML = "";
            //   day.childNodes[1].innerHTML = "0";
            // }
        });
    }
  }

});