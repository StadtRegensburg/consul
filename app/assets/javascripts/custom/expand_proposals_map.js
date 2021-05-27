(function() {
  "use strict";
  App.ExpandProposalsMap = {

    toggleMap: function() {
      var mapDiv = $('#new_map_location')
      var toggler = $(event.target)

      if ( mapDiv.attr("aria-expanded") == "true" ) {
        mapDiv.css('height', '350px')
        mapDiv.attr("aria-expanded","false")
        toggler.attr("aria-expanded","false")
      } else {
        mapDiv.css('height', '700px')
        mapDiv.attr("aria-expanded","true")
        toggler.attr("aria-expanded","true")
      } 

      App.Map.maps.forEach(function(map) { map.invalidateSize() } )
    },

    initialize: function() {

      $("body").on("click", ".expand-proposals-overview-map", function() {
        App.ExpandProposalsMap.toggleMap();
      });
    }
  };
}).call(this);
