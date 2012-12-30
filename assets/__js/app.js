/* ========================================================================
 * app.js
 * http://github.com/jimjh/aladdin
 * ========================================================================
 * Copyright (c) 2012 Carnegie Mellon University
 * License: https://raw.github.com/jimjh/aladdin/master/LICENSE
 * ========================================================================
 */
/*jshint strict:true unused:true*/
/*global $*/

/* Development on this file has stopped. Eventually, the previewer should
 * reference a minified version of the Javascript file from the production
 * site.*/

;(function () {
  'use strict';

  // TODO: refactor

  // Shows results of last submission at the given button and form.
  var showResult = function(form) {
    return function(result) {
      switch(result) {
      case true:
        form.removeClass('error');
        form.addClass('success');
        break;
      case false:
        form.removeClass('success');
        form.addClass('error');
        break;
      default:
        $.each(result, function(i, row) {
          $.each(row, function(j, cell) {
            var input = form.find("input[name='answer["+i+"]["+j+"]']");
            showResult(input)(cell);
          });
        });
      }
    };
  };

  // Adds click listeners to the submit buttons.
  var observeSubmitButton = function() {

    $('a.button.submit').click(function(e) {
      var button = $(e.target);
      var form = button.parents('form');
      $.post(form.attr('action'), form.serialize(), showResult(form));
      return false;
    });

  };

  // Adds click listeners to the run buttons.
  // var run = function() {
  //   $('a.button.run').click(function(e){
  //     var form = $(e.target).parents('form');
  //     var raw = form.find('.ex-raw').val();
  //     var id = form.find('.ex-id').val();
  //     $.post('/verify/code/' + id, raw,
  //       function(data) { console.log(data); }
  //     );
  //     return false;
  //   });
  // };

  var genie = {

    launch: function() {
      observeSubmitButton();
    }

  };

  $(genie.launch());

})();
