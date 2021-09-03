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


    }
  };
}).call(this);
