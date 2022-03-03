(function() {
  "use strict";
  App.CustomPages = {

    initialize: function() {
      $("body").on("click", ".js-icon-toggle-budget-phases", function(event) {
        var $phase = $(this).closest('.sidebar-projekt-phase')
        $phase.attr('aria-expanded', function (i, attr) {
          return attr == 'true' ? 'false' : 'true'
        });

        $(this).attr('aria-expanded', $phase.attr('aria-expanded'))
      })
    }
  }
}).call(this);
