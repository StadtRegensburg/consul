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

        var tabFilterSubnav = document.getElementById('filter-subnav')
        var maxScroll = tabFilterSubnav.scrollWidth - tabFilterSubnav.clientWidth

        if ( $('#filter-subnav').scrollLeft() <= 120 ) {
          $('#left-arrow-control').addClass('disabled')
        }

        if ( $('#filter-subnav').scrollLeft() != maxScroll) {
          $('#right-arrow-control').removeClass('disabled')
        }
      })

      $("body").on("click", ".js-right-arrow-control", function(event) {
        $('#filter-subnav').animate( { scrollLeft: '+=120' }, 1000 );

        var tabFilterSubnav = document.getElementById('filter-subnav')
        var maxScroll = tabFilterSubnav.scrollWidth - tabFilterSubnav.clientWidth

        if ( maxScroll != 0 ) {
          $('#left-arrow-control').removeClass('disabled')
        }

        if ( maxScroll <= $('#filter-subnav').scrollLeft() + 120 ) {
          $('#right-arrow-control').addClass('disabled')
        }

      })


    }
  }
}).call(this);