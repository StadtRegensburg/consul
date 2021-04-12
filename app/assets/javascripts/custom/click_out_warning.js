(function() {
  "use strict";
  App.ClickOutWarning = {
    initialize: function() {
      $("body").on("click", "a", function() {
        alert('test')
      });
    }
  }
}).call(this);
