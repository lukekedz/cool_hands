$(document).ready(function() {
  console.log("anyong");

  clickable = function() {
    console.log("anyong2");
  }

  // setTimeout(function(){
  //   var dateTime = new Date();
  //   var year = dateTime.getFullYear();
  //   var month = dateTime.getMonth();
  //   var localeOf1st = new Date(year, month, 1).getDay();

  //   var monthStart = new Date(year, month, 1);
  //   var monthEnd = new Date(year, month + 1, 1);
  //   var monthLength = Math.floor((monthEnd - monthStart) / (1000 * 60 * 60 * 24));

  //   var week_row = 0
  //   var date = 1

  //   while (week_row <= 5) {
  //     while (localeOf1st <= 6) {
  //       if (date <= monthLength) {
  //         var id = week_row + "-" + localeOf1st;
  //         document.getElementById(id).getElementsByTagName('div')[0].innerHTML = date;
  //       }
  //       localeOf1st ++;
  //       date ++;
  //     }

  //     localeOf1st = 0;
  //     week_row ++;
  //   }
  // }, 1000);
});