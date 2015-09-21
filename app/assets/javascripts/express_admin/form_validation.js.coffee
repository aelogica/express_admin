$ ->
  $('form.validate').validate
    errorElement: 'span'

  email = $('[name$="[email]"]')

  if email.size() > 0
    email.rules 'add',
      required:   true
      email:      true

  password = $('[name$="[password]"]')

  if password.size() > 0
    password.rules 'add',
      required:   true
      minlength:  8

  password_confirmation = $('[name$="[password_confirmation]"]')

  if password_confirmation.size() > 0
    password_confirmation.rules 'add',
      equalTo: $('[name$="[password]"]')
