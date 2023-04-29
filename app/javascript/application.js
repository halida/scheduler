// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"

// import "jquery"
import jquery from "jquery"
window.jQuery = jquery;
window.$ = jquery;

$(document).on("turbo:load", () => {
  console.log("turbo!");
});

import "bootstrap";
