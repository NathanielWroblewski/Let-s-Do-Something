$(document).ready(function(){
  var zip = $('.activity-zip').text().trim();
  $.ajax({
    type: 'post',
    url: '/weather',
    dataType: 'json',
    data: { 'zip': zip }
  }).done(function(response){
    if (response.dates == ""){
      $('<p>No weather data are currently available for this area.</p>').appendTo('.weather-data');
    }
    else {
      var skycons = new Skycons({"color": "#ff3500"});
      $('<div><canvas id="weather-icon" width="64" height="64"><  /canvas></div>' +
        '<h6>Forecast: </h6>' +
        '<p> ' + response.dates + ': Temperature: ' + response.  minTemp + 'F to ' + response.maxTemp + 'F'+
        ', wind: ' + response.windDirection + ', ' + response.  windSpeed + 'mph</p>').hide().appendTo('.weather-data').  fadeIn(1000);
      // SUNNY
      if (response.weatherCode === "113"){
        skycons.add("weather-icon", Skycons.CLEAR_DAY);
      }
      // PARTLY CLOUDY
      else if (response.weatherCode === "116"){
        skycons.add("weather-icon", Skycons.PARTLY_CLOUDY_DAY);
      }
      // CLOUDY
      else if (response.weatherCode === "119" || response.  weatherCode === "122" || response.weatherCode === "200" ){
        skycons.add("weather-icon", Skycons.CLOUDY);
      }
      // FOGGY
      else if (response.weatherCode === "143" || response.  weatherCode === "248" || response.weatherCode === "260"){
        skycons.add("weather-icon", Skycons.FOG);
      }
      // RAINY
      else if (response.weatherCode === "176" || response.  weatherCode === "185" || response.weatherCode === "182" ||   response.weatherCode === "263" || response.weatherCode === "  266" || response.weatherCode === "281" || response.  weatherCode === "284" || response.weatherCode === "293" ||   response.weatherCode === "296" || response.weatherCode === "  299" || response.weatherCode === "302" || response.  weatherCode === "305" || response.weatherCode === "308" ||   response.weatherCode === "311" || response.weatherCode === "  314" || response.weatherCode === "317" || response.  weatherCode === "320" || response.weatherCode === "350" ||   response.weatherCode === "353" || response.weatherCode === "  356" || response.weatherCode === "359" || response.  weatherCode === "362" || response.weatherCode === "365" ||   response.weatherCode === "374" || response.weatherCode === "  377" || response.weatherCode === "386" || response.  weatherCode === "389" ){
        skycons.add("weather-icon", Skycons.FOG);
      }
      // SNOWY
      else if (response.weatherCode === "179" || response.  weatherCode === "227" || response.weatherCode === "230" ||   response.weatherCode === "323" || response.weatherCode === "  326" || response.weatherCode === "329" || response.  weatherCode === "332" || response.weatherCode === "335" ||   response.weatherCode === "338" || response.weatherCode === "  368" || response.weatherCode === "371" || response.  weatherCode === "392" || response.weatherCode === "395"){
        skycons.add("weather-icon", Skycons.SNOW);
      }
      skycons.play();
    }
    }).fail(function(){
    $('<p>No weather data are currently available for this area.</p>').appendTo('.weather-data')
  });
});
