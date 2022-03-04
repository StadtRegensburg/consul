(function() {
  "use strict";
  App.CustomPages = {
    scrollTabsLeft: function() {
      var $tabToShow = $('#filter-subnav li.page-subnav-tab:visible').first().prev()
      var $tabToHide = $('#filter-subnav li.page-subnav-tab:visible').last()
      $tabToShow.show();
      $tabToHide.hide();

      var $firstTab = $('#filter-subnav li.page-subnav-tab').first()
      if ( $firstTab.is(':hidden') ) {
        $('#left-arrow-control').show();
      } else {
        $('#left-arrow-control').hide();
      }

      $('#right-arrow-control').show();
    },

    scrollTabsRight: function() {
      var $tabToShow = $('#filter-subnav li.page-subnav-tab:visible').last().next()
      var $tabToHide = $('#filter-subnav li.page-subnav-tab:visible').first()
      $tabToShow.show();
      $tabToHide.hide();

      var $firstTab = $('#filter-subnav li.page-subnav-tab').first()
      if ( $firstTab.is(':hidden') ) {
        $('#left-arrow-control').show();
      }

      var $lastTab = $('#filter-subnav li.page-subnav-tab').last()
      if ( $lastTab.is(':visible') ) {
        $('#right-arrow-control').hide();
      }
    },

    initialize: function() {
      $("body").on("click", ".js-icon-toggle-budget-phases", function(event) {
        var $phase = $(this).closest('.sidebar-projekt-phase')
        $phase.attr('aria-expanded', function (i, attr) {
          return attr == 'true' ? 'false' : 'true'
        });

        $(this).attr('aria-expanded', $phase.attr('aria-expanded'))
      })

      $("body").on("click", ".js-left-arrow-control", function(event) {
        var $firstTab = $('#filter-subnav li.page-subnav-tab').first()
        if ( $firstTab.css('display') == 'none' ) {
          App.CustomPages.scrollTabsLeft();
        }
      })

      $("body").on("click", ".js-right-arrow-control", function(event) {
        var $lastTab = $('#filter-subnav li.page-subnav-tab').last()

        if ( $lastTab.css('display') == 'none' ) {
          App.CustomPages.scrollTabsRight();
        }
      })
    }
  }
}).call(this);
