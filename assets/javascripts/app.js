/*global $ console*/
;(function () {
  'use strict';

  // TODO: rewrite

  function listen() {

    $('a.button.run').click(function(e){
      var form = $(e.target).parents('form');
      var raw = form.find('.ex-raw').val();
      var id = form.find('.ex-id').val();
      $.post('/verify/code/' + id, raw,
        function(data) { console.log(data); }
      );
      return false;
    });

    $('a.button.submit').click(function(e) {
      var form = $(e.target).parents('form');
      var raw = form.find('select,input[type=text]').val();
      var id = form.find('.q-id').val();
      $.post('/verify/quiz/' + id, raw,
        function(data) { console.log(data); }
      );
      return false;
    });

  }

  $(listen);

})();
