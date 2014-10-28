// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require jquery
//= require jquery_ujs
//= require express_admin/dataTables/jquery.dataTables
//= require express_admin/dataTables/dataTables.foundation
//= require foundation
//= require select2
//= require underscore
//= require underscore.string
//= require jquery.loadingdotdotdot

$(function() {
  _.mixin(_.str.exports());
  $(document).foundation();

  // Table Row as links
  $('.table-hover tr[data-url]').on('click', function() {
    window.location.href = $(this).attr('data-url');
  });

  // Gallery Same height blocks
  if($('ul[data-gallery]').length != 0) {
    var blocks = $('ul[data-gallery] li');
    var maxHeight = Math.max.apply(
      null,
      jQuery.map(blocks, function(num) { return $(num).outerHeight(false); })
    );

    blocks.find('> a.panel').css('height', maxHeight);
  }

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

  // Modal Cancel buttons
  $("a.modal-cancel").click(function(e) {
    e.preventDefault();
    $('a.close-reveal-modal').trigger('click');
  });
});

String.prototype.repeat = function( num )
{
  return new Array( num + 1 ).join( this );
}
