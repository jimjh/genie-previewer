/* ========================================================================
 * app.js
 * http://github.com/jimjh/aladdin
 * ========================================================================
 * Copyright (c) 2012 Carnegie Mellon University
 * License: https://raw.github.com/jimjh/aladdin/master/LICENSE
 * ========================================================================
 */
/*jshint strict:true unused:true*/
/*global $ console*/

;(function () {
  'use strict';

  // TODO: rewrite

  // Adds click listeners to the submit buttons.
  var submit = function() {

    $('a.button.submit').click(function(e) {
      var form = $(e.target).parents('form');
      var id = form.find('input.q-id').val();
      $.post('/verify/quiz/' + id, form.serialize(),
        function(data) { console.log(data); }
      );
      return false;
    });

  };

  // Adds click listeners to the run buttons.
  var run = function() {

    $('a.button.run').click(function(e){
      var form = $(e.target).parents('form');
      var raw = form.find('.ex-raw').val();
      var id = form.find('.ex-id').val();
      $.post('/verify/code/' + id, raw,
        function(data) { console.log(data); }
      );
      return false;
    });

  };

  var listen = function() {
    run();
    submit();
  };

  $(listen);

})();
