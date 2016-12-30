$(document).ready(function() {

  clickable = function(event, blockId, practiced) {
    console.log(event);
    console.log(blockId);
    console.log(practiced);

    var id   = event.target.id;
    var mins = 0;

    if (practiced === false) {
      mins = prompt("Enter practice time (in minutes):");
    }

    if (document.getElementById(id).className === 'day') {
        document.getElementById(id).className = 'green';

      $.ajax({
          type: "POST",
          url: "/site/practiced",
          data: { "block_id": blockId, "practiced": true, "minutes": mins },
          success: function(data){
            console.log(data);
          }
      });
    } else {
        document.getElementById(id).className = 'day';

        $.ajax({
            type: "POST",
            url: "/site/practiced",
            data: { "block_id": blockId, "practiced": false, "minutes": mins },
            success: function(data){
              console.log(data);
            }
        });
    }
  }

});