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

      $("body").on("click", ".js-left-arrow-control", function(event) {
        $('#filter-subnav').animate( { scrollLeft: '-=120' }, 1000 );
      })

      $("body").on("click", ".js-right-arrow-control", function(event) {
        $('#filter-subnav').animate( { scrollLeft: '+=120' }, 1000 );

        // var element = document.getElementById('filter-subnav')
        // var maxScroll = element.scrollWidth - element.clientWidth
      })


    }
  }
}).call(this);
