(function() {
  "use strict";
  App.SDGCustom = {

    updateSDGFilterGoals: function() {
      var url = new URL(window.location.href);
      var clickedSDGCode = $(event.target).parent().attr('data-code');

      if (url.searchParams.get('sdg_goals')) {
        var currentSDGCodes = url.searchParams.get('sdg_goals').split(',');
      } else {
        var currentSDGCodes = [];
      };

      if ( currentSDGCodes.includes(clickedSDGCode)) {
        currentSDGCodes = currentSDGCodes.filter( function(element) { return element !== clickedSDGCode } )
      } else {
        currentSDGCodes.push(clickedSDGCode)
      };

      if ( currentSDGCodes.length > 0 ) {
				url.searchParams.set('sdg_goals', currentSDGCodes.join(','))
      } else {
        url.searchParams.delete('sdg_goals')
      };

      window.history.pushState('', '', url);
      window.location.href = url.href;
    },

    updateSDGFilterTargets: function(selectedValue) {
      var url = new URL(window.location.href);

      if (url.searchParams.get('sdg_targets')) {
        var currentSDGTargetCodes = url.searchParams.get('sdg_targets').split(',');
      } else {
        var currentSDGTargetCodes = [];
      }

      currentSDGTargetCodes.push(selectedValue);
      url.searchParams.set('sdg_targets', currentSDGTargetCodes.join(','))

      window.history.pushState('', '', url);
      window.location.href = url.href;
    },

    initialize: function() {
      $("body").on("click", ".js-sdg-custom-goal-filter", function(event) {
        event.preventDefault();
        App.SDGCustom.updateSDGFilterGoals();
      });

      $("body").on("change", ".js-sdg-custom-target-filter", function(event) {
        var selectedValue = event.target.value;
        App.SDGCustom.updateSDGFilterTargets(selectedValue);
      });
    }
  };
}).call(this);
