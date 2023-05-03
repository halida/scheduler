// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "modules/jquery-global";
import "bootstrap";
import "select2";
import "magnific-popup";
import "bootstrap-datepicker";

import "modules/list_as_day";

$(document).on("turbo:load", () => {
  console.log("turbo!");

  $(".select2").select2({allowClear: true});

  $(".date-picker").datepicker({
    changeMonth: true,
    changeYear: true
  });
  $('.toggle-popup').magnificPopup({type: 'inline'});

});


// $(document).on("turbo:before-cache", () => {
//   // fixed by https://stackoverflow.com/questions/36497723/select2-with-ajax-gets-initialized-several-times-with-rails-turbolinks-events
//   $('.select2').select2('destroy');
// });

