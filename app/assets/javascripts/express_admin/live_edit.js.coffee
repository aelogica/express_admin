$(document).on 'ready', (event) ->
  # Need to take this out after dev spike since this file is injected through designer
  $('.h-box, .v-box, .pane, .sidebar-region, .main-region').addClass 'live-edit'

  $(document).on 'mouseenter', '.live-edit', (e) ->
    $('.live-edit')
      .removeClass 'current-component'
    $('.pop-up-modal').remove()

    $(e.target).closest('.live-edit').addClass 'current-component'
    $(e.target).closest('.current-component').prepend('<a class="pop-up-modal">Show Modal</div>')

  .on 'mouseleave', '.current-component', ->
    $('.pop-up-modal').remove()

  .on 'click', '.pop-up-modal', ->
    $('#my-modal').addClass 'is-active'
    $('#my-modal > .modal').addClass 'is-active'

  .on 'click', '.modal .close-button', (e) ->
    $(e.target).parents('.modal, .modal-overlay').removeClass 'is-active'

