(function() {
  var $toggle_list_by_day_status;

  $toggle_list_by_day_status = true;

  window.toggle_list_by_day = function(hour) {
    var show;
    if (hour !== null) {
      show = $("#hour-executions-" + hour).is(":visible");
      console.log(hour, show);
      $("#hour-executions-" + hour).slideToggle(show);
      $("#hour-executions-header-" + hour).slideToggle(!show);
      return;
    }
    $('.hour-executions').slideToggle($toggle_list_by_day_status);
    $('.hour-executions-header').slideToggle(!$toggle_list_by_day_status);
    return $toggle_list_by_day_status = !$toggle_list_by_day_status;
  };

}).call(this);
