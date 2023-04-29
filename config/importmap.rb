# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "magnific-popup", to: "https://ga.jspm.io/npm:magnific-popup@1.1.0/dist/jquery.magnific-popup.js"
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.6.4/dist/jquery.js"
pin "select2", to: "https://ga.jspm.io/npm:select2@4.1.0-rc.0/dist/js/select2.js"

pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.1.3/dist/js/bootstrap.esm.js"
pin "@popperjs/core", to: "https://unpkg.com/@popperjs/core@2.11.2/dist/esm/index.js" # use unpkg.com as ga.jspm.io contains a broken popper package

# pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@3.4.1/dist/js/npm.js"
# pin "bootstrap-datepicker", to: "https://ga.jspm.io/npm:bootstrap-datepicker@1.9.0/dist/js/bootstrap-datepicker.js"
