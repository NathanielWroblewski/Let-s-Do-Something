function toType(){
$('input#search').attr('placeholder', '');
    var chars = sentencesToAutofill[index].split('');
    var charIndex = 0;
    var printChars = setInterval(function() {
      if(charIndex == chars.length-1) clearInterval(printChars);
      var currentHolder = $('input#search').attr('placeholder');
      $('input#search').attr('placeholder', currentHolder+chars[charIndex]);
      charIndex++;
    }, 50);
    if (index < sentencesToAutofill.length - 1){
      index++;
    }
    else{
      index = 0;
    }
}

$(document).ready(function(){
  $('input#search').attr('placeholder', 'What would you like to do?')
  index = 0
  sentencesToAutofill = ["I want to hit the slopes in Tahoe next week", "We want to go bungee jumping for between $50 and $100", "Where can I go hiking in San Francisco?", "Show me some fireworks on Valentine's Day"]
  setInterval(function() {toType()}, 4000)
});
