$toggle_list_by_day_status = true

window.toggle_list_by_day = (hour=null)->
    if hour != null
        show = $("#hour-executions-#{hour}").is(":visible")
        console.log(hour, show)
        $("#hour-executions-#{hour}").slideToggle(show)
        $("#hour-executions-header-#{hour}").slideToggle(! show)
        return

    # console.log $toggle_list_by_day_status
    $('.hour-executions').slideToggle($toggle_list_by_day_status)
    $('.hour-executions-header').slideToggle(! $toggle_list_by_day_status)
    $toggle_list_by_day_status = ! $toggle_list_by_day_status
