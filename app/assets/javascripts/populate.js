$(document).ready(function(){
  $(document).on('keyup','#search', function(){
    var selectedCategories = [];
    var search             = this.value;
    var category           = $('#category :selected').each(function(i, selected){
      selectedCategories[i] = $(selected).text();
    });
    var startsAt           = $('#starts_at').value;
    var endsAt             = $('#ends_at').value;
    var streets            = $('#streets')[0].value;
    var cities             = $('#cities')[0].value;
    var regions            = $('#regions')[0].value;
    var zips               = $('#zips')[0].value;
    var minPrice           = $('#min_price')[0].value;
    var maxPrice           = $('#max_price')[0].value;

    $.ajax({
      type: 'post',
      url: 'activities/populate',
      dataType: 'json',
      data: { search:    search,
        category:  selectedCategories,
        starts_at: startsAt,
        ends_at:   endsAt,
        streets:   streets,
        cities:    cities,
        regions:   regions,
        zips:      zips,
        min_price: minPrice,
        max_price: maxPrice
      }
    }).done(function(response){

      if (response.category.length >= 1) {
        $('#what-search').find('.form-hidden').show("blind",500);
      } else {
        $('#what-search').find('.form-hidden').hide("blind", 500);
      }
      $('#category').val(response.category);

      if (response.street.length >= 1 || response.city.length >= 1 || response.zip.length >= 1 || response.region.length >= 1) {
        $('#where-search ').find('.form-hidden').show("blind",500);
      } else {
        $('#where-search ').find('.form-hidden').hide("blind", 500);
      }
      $('#streets').val(response.street[0]);
      $('#cities').val(response.city[0]);
      $('#regions').val(response.region[0]);
      $('#zips').val(String(response.zip[0]));

      if (response.max_price >= 1 || response.min_price >= 1) {
        $('#how-much-search').find('.form-hidden').show("blind",500);
      } else {
        $('#how-much-search').find('.form-hidden').hide("blind", 500);
      }
      $('#max_price').val(response.max_price);
      $('#min_price').val(response.min_price);

      if (response.starts_at.length >= 1 || response.ends_at.length >= 1) {
        $('#when-search').find('.form-hidden').show("blind",500);
      } else {
        $('#when-search').find('.form-hidden').hide("blind", 500);
      }
      $('#starts_at').val(response.starts_at);
      $('#ends_at').val(response.ends_at);
    });
  });
});
