function getList(address) {
  $.ajax({
    type: 'post',
    url: address,
    dataType: 'json'
  }).done(function(response) {
    $("#list").replaceWith(response.html);
  });
  document.location.hash = (address.replace(/\/activities\/search/g, ''));
}


$(document).ready(function() {
// var questions = ["#what-search", "#when-search", "#where-search", "#how-much-search"];
//   $.each(questions, function(index, value) {
//     $(value).on( 'mouseover', function(){
//        console.log($(this).children());
//     });
//   });

$('#when-search').on('click', 'p', function(){
  $('#when-search').find('.form-hidden').toggle("blind",500);
});

$('#where-search').on('click', 'p', function(){
  $('#where-search').find('.form-hidden').toggle("blind",500);
});


$('#what-search').on('click', 'p', function(){
  $('#what-search').find('.form-hidden').toggle("blind",500);
});


$('#how-much-search').on('click', 'p', function(){
  $('#how-much-search').find('.form-hidden').toggle("blind",500);
});

  // $("select").multiselect(); 

  $(document).on('click', '#pagination p a', function(e){
    e.preventDefault();
    var self = this;
    document.location.hash = ($(self).attr('href').replace(/\/activities\/search/g, ''));
    getList($(self).attr('href'));
  });

  $('html').keyup(function(e){
    if (e.keyCode === 8 && document.location.pathname === "/activities/search") {
      e.preventDefault();
      var address = document.location.pathname + document.location.hash.replace(/#/, '');
      getList(address);
    }
  });
});