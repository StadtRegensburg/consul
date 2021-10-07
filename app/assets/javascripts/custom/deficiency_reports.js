(function() {
  "use strict";
  App.DeficiencyReports = {

    updateDeficiencyReportsParams: function($checkbox) {
      var url = new URL(window.location.href);
      var selectedCategoriesIds;
      var uniqueCategoriesIds;

      if (url.searchParams.get('dr_categories')) {
        selectedCategoriesIds = url.searchParams.get('dr_categories').split(',');
      } else {
        selectedCategoriesIds = [];
      }

      if ( $checkbox.is(':checked') ) {
        selectedCategoriesIds.push($checkbox.val());
      } else {
        var index = selectedCategoriesIds.indexOf($checkbox.val());
        if (index > -1) {
          selectedCategoriesIds.splice(index, 1);
        }
      }

      var uniqueCategoriesIds = selectedCategoriesIds.filter( function(v, i, a) { return a.indexOf(v) === i } );

      if ( uniqueCategoriesIds.length > 0 ) {
        url.searchParams.set('dr_categories', uniqueCategoriesIds.join(','))
      } else {
        url.searchParams.delete('dr_categories')
      }

      window.history.pushState('', '', url)
    },

    resetCategoryFilter: function() {
      $('#deficiency-report-categories-sidebar-filter input').each(
        function() {
          $(this).prop('checked', false)
        }
      )

      var url = new URL(window.location.href);
      url.searchParams.delete('dr_categories');
      window.history.pushState('', '', url);
      window.location.href = url;
    },

    initialize: function() {
      $("body").on("click", ".js-filter-dr-category", function() {
				var $checkbox = $(this)
        App.DeficiencyReports.updateDeficiencyReportsParams($checkbox)
      });


      $("body").on("click", ".js-reset-dr-category-filter", function() {
        App.DeficiencyReports.resetCategoryFilter()
      });
    }

  };
}).call(this);
