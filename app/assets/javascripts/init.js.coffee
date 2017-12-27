document.addEventListener "turbolinks:load", ->
    $(".select2").select2(allowClear: true)

    $(".date-picker").datepicker(
        changeMonth: true,
        changeYear: true
    )
    $('.toggle-popup').magnificPopup(type: 'inline')

document.addEventListener "turbolinks:before-cache", ->
    # fixed by https://stackoverflow.com/questions/36497723/select2-with-ajax-gets-initialized-several-times-with-rails-turbolinks-events
    $('.select2').select2('destroy')

