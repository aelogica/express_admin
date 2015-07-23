$(document).on 'ready', (event) ->
  # Need to take this out after dev spike since this file is injected through designer
  $('.h-box, .v-box, .pane, .sidebar-region, .main-region').addClass 'live-edit'

  $(document).on 'mouseenter', '.live-edit', ->
    $('.live-edit').removeClass 'current-component'
    $(this).addClass 'current-component'

  .on 'click', '#users', ->
    $('#my-modal').addClass 'is-active'
    $('#my-modal > .modal').addClass 'is-active'

  .on 'click', '.modal .close-button', ->
    $(this).parents('.modal, .modal-overlay').removeClass 'is-active'

