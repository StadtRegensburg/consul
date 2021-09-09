(function() {
  "use strict";
  App.PollsCustom = {

    hideOpenAnswers: function() {
      $('.poll-results-open-answers-list').hide()
    },

    initialize: function() {
      App.PollsCustom.hideOpenAnswers()

      $("body").on("click", ".js-show-open-answers", function() {
        $openAnswersList = $(this).siblings('.poll-results-open-answers-list')
        $(this).siblings('.poll-results-open-answers-list'.toggle();
        
      });
    }

  }
}).call(this);
