/*
 * Javascript action for the JogginMate prototype. Requires jQuery to be loaded already.
 */
function setupNumberIncrementor($div, inc, settingId, defaultVal)
{
  var number = defaultVal;
  $div
    .find('.number')
      .val(number)
    .end()
    .find('.up')
      .click(function() {
        number += inc;
        $div.find('.number').text(number);
        updateIntegerSetting(settingId, number);
      })
    .end()
    .find('.down')
      .click(function() {
        if(number - inc < 0) return;      
        number -= inc;
        $div.find('.number').text(number);
        updateIntegerSetting(settingId, number);          
      })
    .end();
      


}

function updateIntegerSetting(settingId, settingValue)
{
  eval("settings." + settingId + " = " + settingValue);
}

var ticks = 0;
var tick = function() {
  //tick tock it's a clock
  var sdegree = (ticks) * 6;
  var srotate = "rotate(" + sdegree + "deg)";  
  $("#seconds").css({"-moz-transform" : srotate, "-webkit-transform" : srotate});
  
  var mdegree = (Math.floor(ticks / 60)) * 6;
  var mrotate = "rotate(" + mdegree + "deg)";
  $("#minutes").css({"-moz-transform" : mrotate, "-webkit-transform" : mrotate});      

  ticks++;

}

$(function() {
  //DOM ready

  //setup nav buttons
  $('#customize, #back-to-customize').click(function() {
    $(this).closest('#app').removeClass().addClass('custom');
  });

  $('#alerts').click(function() {
    $(this).closest('#app').removeClass().addClass('alerts');
  }); 

  $('.start').click(function() { 
    $(this).closest('#app').removeClass().addClass('jogging');
    //jogging tick action
    tickInterval = setInterval(tick, 1000);  
  });

  $('.stop').click(function() {
    $(this).closest('#app').removeClass().addClass('default');
    ticks = 0;

    //settimeout so it redraws at 0 then stops.
    setTimeout(function(){clearInterval(tickInterval);},1000);
  });
  
  //alert buttons
  $('.button-checkbox').click(function() {
    var $this = $(this),
        settingId = $this.attr('id').toUpperCase();

    $this.toggleClass('selected');

    eval("settings." + settingId + " = ! settings." + settingId);
  });

  //setup app & variables
  settings = {
      PACE: 5,
      DISTANCE: 1,
      HYDRATE: true,
      HEARTRATE: true,
      CALORIES: true,
      OBSTACLES: true,
      MILESTONES: true,
      WEATHER: true
    };

  setupNumberIncrementor($('#distance-inc'), 1.0, "DISTANCE", settings.DISTANCE);
  setupNumberIncrementor($('#pace-inc'), 0.5, "PACE", settings.PACE);

  //alerts
  $('#app').bind('alert', function(event, soundFileName) {
    console.log(soundFileName);

    //play sound here, maybe
    //TODO differentiate between alerts with multiple levels (milestones, calories)
    //also TODO: find a good way to loop audio files so that multiple can be synced
    var snd = new Audio("data/" + soundFileName + ".wav");
    snd.play();

  });

  $('.alert').click(function() {
    $('#app').trigger('alert', $(this).attr('id'));
  });

});

