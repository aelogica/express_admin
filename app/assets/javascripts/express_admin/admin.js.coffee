class AceInput
  constructor: (editor)->
    @editor   = ace.edit(editor)
    @editor.$blockScrolling = Infinity
    @session  = @editor.getSession()
    @renderer = @editor.renderer
    @textarea = $("##{$(editor).data('target')}")
    @setOptions()
    @updateMode()
    @updateTheme()
    @bindTextarea()
    @editor.setFontSize "16px"

  setOptions: =>
    @renderer.setShowPrintMargin false
    @renderer.setHScrollBarAlwaysVisible false
    @session.setUseWorker false
    @session.setTabSize 2
    @session.setUseSoftTabs true
    @session.setFoldStyle "markbeginend"

  updateMode: =>
    mode = require("ace/mode/ruby").Mode
    @session.setMode new mode()

  updateTheme: =>
    @editor.setTheme require("ace/theme/github")

  bindTextarea: =>
    ace = @
    ace.session.setValue ace.textarea.val()
    ace.session.on "change", ->
      ace.textarea.val ace.session.getValue()

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
  $('.ace-input').each (index)->
    editor = new AceInput(this)

String::repeat = (num) ->
  new Array(num + 1).join this
