// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require jquery
//= require jquery_ujs
//= require foundation
//= require select2
//= require underscore
//= require underscore.string
//= require jquery.loadingdotdotdot

$(function() {
  _.mixin(_.str.exports());
  $(document).foundation();

  $(".megamenu").mouseenter(function(){
    if($(window).width()>641){
      $(".dropdown-wrapper").offset({left: 0});
      $(".dropdown-wrapper").css("width",$(window).width());
    }else{
      $(".dropdown-wrapper").css("width",auto);
    }
  });

  window.startAnimateProgress = function(message) {
    $('#nav-js-alert').html("<div class='alert-box'></div>");
    $('#nav-js-alert .alert-box').Loadingdotdotdot({
      "word": message
    }).addClass('info');
    $('#nav-js-alert').show();
  };

  window.stopAnimateProgress = function() {
    $('#nav-js-alert .alert-box').Loadingdotdotdot("Stop");
  };

  $(".gallery a.addon").click(function(e) {
  e.preventDefault();
  });

  $("a.modal-cancel").click(function(e) {
    e.preventDefault();
    $('a.close-reveal-modal').trigger('click');
  });
});
