$(document).ready(function() {

  clickable = function(event, blockId) {
    console.log(event);
    console.log(blockId);
    var id = event.target.id;

    if (document.getElementById(id).className === 'day') {
        document.getElementById(id).className = 'green';

      $.ajax({
          type: "POST",
          url: "/site/practiced",
          data: { "block_id": blockId, "practiced": true },
          success: function(data){
            console.log(data);
          }
      });
    } else {
        document.getElementById(id).className = 'day';

        $.ajax({
            type: "POST",
            url: "/site/practiced",
            data: { "block_id": blockId, "practiced": false },
            success: function(data){
              console.log(data);
            }
        });
    }
  }

});