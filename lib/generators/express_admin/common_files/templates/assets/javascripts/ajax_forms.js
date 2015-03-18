$(function() {
  function successfulResponse() {
    updateButton('success', 'Record saved')

    datatable.ajax.reload();

    toggleFormTo('New', $('.ajax-form form').attr('action'));
  }

  function failureResponse() {
    updateButton('error', 'Record not saved');
  }

  function updateButton(status, message, time) {
    button = $('.ajax-submit');
    button.blur().attr('disabled', true).addClass(status).val(message);
    time = time || 2

    setTimeout(function() {
      button = $('.ajax-submit');
      button.val('Save').removeClass(status).removeAttr('disabled');
    }, time * 1000);
  }

  function populateFields(data, modelName) {
    dataModel = eval('data.'+modelName);
    keys = Object.keys(dataModel);

    $.each(keys, function(index, key) {
      $('#'+modelName+'_'+key).val(eval('dataModel.'+key));
    });
  }

  function toggleForm(url) {
    ajaxForm = $('.ajax-form');
    toggleFormTo('Edit', url);
    ajaxForm.find('.cancel').text('Cancel').removeClass('hide');
  }

  function toggleFormTo(text, url) {
    form = $('.ajax-form form');
    widgetHeader = $('.widget-header span');
    widgetText = widgetHeader.text();

    if (text == 'Edit') {
      widgetHeader.text(widgetText.replace(/New/, 'Edit'));
      form.attr('method', 'put');
    } else {
      widgetHeader.text(widgetText.replace(/Edit/, 'New'));
      form.attr('method', 'post');
      form[0].reset();
      form.find('.cancel').addClass('hide');
    }
    form.attr('action', url)
  }

  $(document).on('click', '.ajax-submit', function(){
    $this  = $(this);
    form   = $this.closest('form');
    data   = form.serializeArray();
    url    = form.attr('action');
    method = form.attr('method');

    $('.error').removeClass('error');

    if ($('.required').length > 0) {
      $('.required').each(function(){
        if ($(this).val() == '') {
          $(this).addClass('error');
        }
      })

      if ($('.error').length > 0) {
        $('.error').first().focus();
        return;
      }
    }

    $this.val('Saving...').css('transition','none');

    AJAXRequest(url, method, data, successfulResponse, failureResponse);
    return false;
  }).
  on('click', '.edit-link', function(e) {
    recordLink = $(e.target).attr('href')
    $.get(recordLink, function(data) {
      modelName = $(e.target).attr('data-model');
      populateFields(data, modelName);

      toggleForm(recordLink);
    }, 'json');
  }).
  on('ajax:success', '.ajax-submit', function(e) {
  }).
  on('click', '.cancel', function(e) {
    toggleFormTo('New', $(e.target).attr('href'));
  }).
  on('ajax:success', '.delete-link', function(e) {
    datatable.ajax.reload();
  });
})
