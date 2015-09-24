$( document ).ready(function() {
  $(document).
    on('click', '.sub-menu-expander', function(e) {
      $(this).parent().find('.sub-menu').removeClass('hidden');
    }).
    on('click', '.main-page', function(e) {
      // quick hack for now
      $('.sub-menu').addClass('hidden');
    });
})
