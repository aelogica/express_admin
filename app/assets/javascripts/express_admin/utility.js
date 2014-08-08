$(function() {

  // toggle on/off switch
  $(document).on('click', '[data-toggle]', function() {
    targetHide = $(this).data('toggle-hide')
    targetShow = $(this).data('toggle-show')
    $('[data-toggle-name="' + targetHide  + '"]').addClass('hide')
    $('[data-toggle-name="' + targetShow  + '"]').removeClass('hide')
  });

  // AJAX request utility
  AJAXRequest = function(url, data, success, error)
  {
    $.ajax({
        url      : url,
        type     : 'POST',
        data     : data,
        dataType : 'JSON',
        cache    : false,
        success  : function(json)
        {
              success(json)
            },
        error    : function()
        {
              error()
            }
      });
  }
});
