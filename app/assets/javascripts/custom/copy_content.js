(function() {
  "use strict";
  App.CopyContent = {
    initialize: function() {
      $(".js-copy-source-button").on("click", function() {
        var targetId = $(this).data('target');
        navigator.clipboard.writeText( $(targetId).html() );
      });
    }
  };
}).call(this);
