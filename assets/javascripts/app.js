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

;(function () {
  'use strict';

  // TODO: refactor

  // Shows results of last submission at the given button and form.
  var showResult = function(button, form) {
    return function(result) {
      switch(result) {
      case true:
        button.addClass('success');
        form.removeClass('error');
        break;
      case false:
        button.removeClass('success');
        form.addClass('error');
        break;
      default:
        $.each(result, function(i, row) {
          $.each(row, function(j, cell) {
            var input = form.find("input[name='answer["+i+"]["+j+"]']");
            if (cell) input.addClass('success'); else input.addClass('error');
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
      var id = form.find('input.q-id').val();
      $.post('/verify/quiz/' + id, form.serialize(), showResult(button, form));
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
