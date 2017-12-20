window.init = ->
    $(".select2").select2(allowClear: true)
    $(".date-picker").datepicker(
        changeMonth: true,
        changeYear: true
    )
    $('.fancybox').fancybox()

document.addEventListener("turbolinks:load", init)
