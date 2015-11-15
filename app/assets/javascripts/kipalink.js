var elementSetting = function() {
  $('.voted.item').bind('touchstart', function(e){
    e.preventDefault();
  });
  if ($('.cmts-area').length){
    $('.cmts-area').autosize();
  }
  if ($('.idea-area').length){
    $('.idea-area').autosize();
  }
}

$(document).ready(function() {

  /* Setting for elements in screen */
  elementSetting()

})
