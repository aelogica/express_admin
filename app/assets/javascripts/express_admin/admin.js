$(function() {
  $(document).foundation();

  // Table Row as links
  $('.table-hover tr[data-url]').on('click', function() {
    window.location.href = $(this).attr('data-url');
  });

  window.startAnimateProgress = function(message) {
    $('.content-body').prepend("<div class='alert-box'></div>");
    $('.content-body .alert-box').Loadingdotdotdot({
      "word": message
    }).addClass('info');
  };

  window.stopAnimateProgress = function() {
    $('.alert-box').Loadingdotdotdot("Stop");
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
