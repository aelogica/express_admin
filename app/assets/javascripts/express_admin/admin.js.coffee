$(document).ready ->
  $('.select2').select2()
  # Table Row as links
  $('.table-hover tr[data-url]').on 'click', ->
    window.location.href = $(this).attr('data-url')
    return

  window.startAnimateProgress = (message) ->
    $('.content-body').prepend '<div class=\'alert-box\'></div>'
    $('.content-body .alert-box').Loadingdotdotdot('word': message).addClass 'info'
    return

  window.stopAnimateProgress = ->
    $('.alert-box').Loadingdotdotdot 'Stop'
    return

  # Modal Cancel buttons
  $('a.modal-cancel').click (e) ->
    e.preventDefault()
    $('a.close-reveal-modal').trigger 'click'
    return

String::repeat = (num) ->
  new Array(num + 1).join this
