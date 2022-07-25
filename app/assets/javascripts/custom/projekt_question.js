(function() {
  "use strict";
  App.ProjektQuestionCustom = {
    initialize: function() {
      $("body").on("click", ".js-projekt-question-next", function(e) {
        e.preventDefault()
        e.stopPropagation()
        this.loadQuestionSection(e.currentTarget.href)
      }.bind(this));

      $('body').on('change', '.js-projekt-answer-form input', this.debounce(this.submitForm.bind(this), 500))
      $('body').on('click', '.js-projekt-answer-form label', this.handleCheckboxClick.bind(this))
    },

    debounce: function(func, duration, immediate) {
      var timeout;

      return function() {
        var context = this, args = arguments;
        var later = function() {
          timeout = null;
          if (!immediate) func.apply(context, args);
        };
        var callNow = immediate && !timeout;

        clearTimeout(timeout);
        timeout = setTimeout(later, duration);

        if (callNow) func.apply(context, args);
      };
    },

    loadQuestionSection: function(url) {
      $.get(url)
    },

    submitForm: function(e) {
      var $element = $(e.currentTarget)
      $element.closest('form').trigger('submit.rails')
      var $elementLabel = $element.parent('label')

      $elementLabel.parent().find('label input[type="radio"]').prop('disabled', true)

      $elementLabel.siblings('label').removeClass('is-active')
      $elementLabel.addClass('is-active')
      $(".js-projekt-question-section").addClass("show-loader");
    },

    handleCheckboxClick: function(e) {
      var $elementForm = $(e.currentTarget).closest('form')
      var isLogined = $elementForm.attr('data-logined')
      var redirectTo = $elementForm.attr('data-redirect-to')

      if (isLogined === 'false') {
        Turbolinks.visit(redirectTo)
      }
    }
  }
}).call(this);
