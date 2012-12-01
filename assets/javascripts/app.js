/*global $ console*/
;(function () {
  'use strict';

  // TODO: rewrite

  function listen() {
    $('a.button.run').click(function(e){
      var form = $($(e.target).attr('href'));
      var raw = form.find('.ex-raw').val();
      var id = form.find('.ex-id').val();
      $.post('/verify/' + id, raw,
        function(data) { console.log(data); }
      );
      return false;
    });
  }

  $(listen);

})();
