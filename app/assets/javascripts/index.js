$(document).ready(function() {

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

    if (day.className === 'day') {
        day.className = 'green';

      $.ajax({
          type: "POST",
          url: "/site/practiced",
          data: { "block_id": blockId, "practiced": 1, "minutes": mins },
          success: function(data){
            // console.log(data);
            day.childNodes[5].innerHTML = mins + " mins";
            day.childNodes[1].innerHTML = "1";

          }
      });
    } else {
        day.className = 'day';

        $.ajax({
            type: "POST",
            url: "/site/practiced",
            data: { "block_id": blockId, "practiced": 0, "minutes": null },
            success: function(data){
              // console.log(data);
              day.childNodes[5].innerHTML = "";
              day.childNodes[1].innerHTML = "0";


            }
        });
    }
  }

});