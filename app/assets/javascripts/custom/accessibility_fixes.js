(function() {
  "use strict";
  App.AccessibilityFixes = {
    clickLabelAdjasentButton: function($label) {
      var inputFileId = $label.attr('for')
      var inputFileIdString = '#' + inputFileId
      $(inputFileIdString).trigger('click');
    },

    initialize: function() {
      $('body').on('keyup', '.js-access-label-to-button', function(event) {
        if (event.which === 13) {
          event.preventDefault()
          var $label = $(this)
          App.AccessibilityFixes.clickLabelAdjasentButton($label)
        }
      })

      $('body').on('keyup', '.js-access-toggle-projekt-filter-checkbox', function(event) {
        if ( event.which === 32 || // space
             event.which === 13  ) { // enter
          $(this).siblings('input.js-filter-projekt').trigger('click');
        }
      })

      $('body').on('keydown', '.js-prevent-key-scroll', function(event) {
        if ( event.which === 37 ||  // left arrow
             event.which === 38 ||  // up arrow
             event.which === 39 ||  // right arrow
             event.which === 40 ||  // down arrow
             event.which === 32     // space
           ) {
          event.preventDefault();
        }
      })

      $('body').on('keyup', '.js-icon-toggle-child-projekts', function(event) {
        event.preventDefault();
        var $toggleArrow = $(this);
        var arrowExpanded = $toggleArrow.attr('aria-expanded') == "true"

        if ( ( event.which === 38 && arrowExpanded  ) || // up arrow and expanded
             ( event.which === 40 && !arrowExpanded ) ) { // down arrow and closed

          App.Projekts.toggleChildrenInSidebar($toggleArrow.closest('li'))

        }

      })


    }
  };
}).call(this);
