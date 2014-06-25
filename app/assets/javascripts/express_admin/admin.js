// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require jquery
//= require jquery_ujs
//= require foundation
//= require select2
//= require underscore
//= require underscore.string

$(function() {
  _.mixin(_.str.exports());
  $(document).foundation();

  window.startAnimateProgress = function(message) {
    var numberOfDots = 3;
    var dots = numberOfDots - 1;
    var dotSpan = "";
    for(i = 0; i < dots; i++) {
      dotSpan += "<span class='dot'>.</span>"
    }
    $('#nav-js-alert .alert-box').html(message + "." + dotSpan);

    window.intervalId = setInterval( function() {

      for(i = 0; i < dots; i++) {
        $($('.dot')[i]).removeClass('dot')
      }

      dots++;
      if (dots > numberOfDots) {
        $('#nav-js-alert .alert-box span').addClass('dot')
        dots = 1;
      }

    }, 500)
    $('#nav-js-alert .alert-box').addClass('info');
    $('#nav-js-alert').show();
  };

  window.stopAnimateProgress = function() {
    clearInterval(window.intervalId);
  };

  $(".gallery a.addon").click(function(e) {
  e.preventDefault();
  });

  $("a.addon-cancel").click(function(e) {
    e.preventDefault();
    $('a.close-reveal-modal').trigger('click');
  });
});
